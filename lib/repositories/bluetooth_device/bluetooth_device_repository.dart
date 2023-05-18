import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.bluetooth});

  final FlutterBluePlus bluetooth;
  final List<MedTechDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;
  late StreamSubscription<BluetoothDeviceState> _connection;

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
    debugPrint('scanForDevices: Starting...');
    bluetoothDevices.clear();
    _scanSubscription?.cancel();
    _scanSubscription = _startScan().listen((result) {
      BluetoothDevice device = result.device;
      debugPrint('scanForDevices: Discovered ${device.name} (${device.id.id})');
      final indexOfDevice =
      bluetoothDevices.indexWhere((d) => (device.id.id == d.id));
      if (indexOfDevice < 0) {
        // if (indexOfDevice < 0 && device.name.isNotEmpty) {
        debugPrint('scanForDevices: Adding new device ${device.name}');
        final medTechDevice = MedTechDevice(
          name: device.name,
          id: device.id.id,
        );
        bluetoothDevices.add(medTechDevice);
        devicesListBloc.add(SetDevicesList(bluetoothDevices));
      } else if (device.name.isNotEmpty) {
        debugPrint('scanForDevices: Updating existing device ${device.name}');
        bluetoothDevices[indexOfDevice] =
            MedTechDevice(name: device.name, id: device.id.id);
      }
    }, onError: (error) {
      debugPrint('scanForDevices: An error occurred - $error');
      devicesListBloc.add(LoadingFalure(exception: error, status: BluetoothState.off));
    });
  }


  @override
  Future<void> connect(String? deviceId) async {
    final completer = Completer<void>();
    debugPrint('Connecting to $deviceId');

    try {
      var scanResult = await bluetooth.startScan(
        withServices: [],
        timeout: Duration(seconds: 10),
      );
      var device = scanResult.firstWhere((r) => r.device.id.toString() == deviceId);
      await device.device.connect();
      _connection = device.device.state.listen((BluetoothDeviceState state) {
        debugPrint('ConnectionState for device $deviceId : $state');
        if (state == BluetoothDeviceState.connected && !completer.isCompleted) {
          completer.complete();
        }
      });
    } catch (e) {
      debugPrint('Connecting to device $deviceId resulted in error $e');
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
    }

    return completer.future.timeout(const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timeout'));
  }



  Stream<ScanResult> _startScan() {
    StreamController<ScanResult> scanResultController = StreamController<ScanResult>();

    bluetooth.scanResults.listen((List<ScanResult> results) {
      results.forEach((result) {
        scanResultController.add(result);
      });
    });

    bluetooth.startScan(timeout: Duration(seconds: 10));

    Future.delayed(Duration(seconds: 10), () async {
      await bluetooth.stopScan();
      scanResultController.close();
    });

    return scanResultController.stream;
  }



  @override
  Future<void> stopScan() async {
    await bluetooth.stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }
}
