import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.bluetooth});

  final FlutterBluetoothSerial bluetooth;
  final List<MedTechDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;
  Future<BluetoothConnection>? _connection;

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
    debugPrint('scanForDevices: Starting...');
    bluetoothDevices.clear();
    _scanSubscription?.cancel();
    _scanSubscription = _startScan().listen((result) {
      BluetoothDevice device = result.device;
      debugPrint('scanForDevices: Discovered ${device.name} (${device.address})');
      final indexOfDevice = bluetoothDevices.indexWhere((d) => (device.address == d.id));
      if (indexOfDevice < 0 && device.name != null && device.name!.isNotEmpty) {
        debugPrint('scanForDevices: Adding new device ${device.name}');
        final medTechDevice = MedTechDevice(
          name: device.name ?? '',
          id: device.address,
        );
        bluetoothDevices.add(medTechDevice);
        devicesListBloc.add(SetDevicesList(bluetoothDevices));
      } else if (device.name != null && device.name!.isNotEmpty) {
        debugPrint('scanForDevices: Updating existing device ${device.name}');
        bluetoothDevices[indexOfDevice] = MedTechDevice(name: device.name ?? '', id: device.address);
      }
    }, onError: (error) async {
      debugPrint('scanForDevices: An error occurred - $error');
      BluetoothState currentState = await FlutterBluetoothSerial.instance.state;
      devicesListBloc.add(LoadingFalure(exception: error, status: currentState));
    });
  }

  @override
  Future<void> connect(String? deviceId) async {
    // final completer = Completer<void>();
    //
    // // Handle the possibility that deviceId could be null
    // if (deviceId == null) {
    //   debugPrint('DeviceId is null');
    //   completer.completeError(Exception('DeviceId is null'));
    //   return completer.future;
    // }
    //
    // debugPrint('Connecting to $deviceId');
    //
    // try {
    //   _connection = FlutterBluetoothSerial.instance.connect(BluetoothDevice(address: deviceId)) as Future<BluetoothConnection>?;
    //   await _connection?.then((connection) {
    //     debugPrint('Connected to the device');
    //     completer.complete();
    //   }).catchError((error) {
    //     debugPrint('Cannot connect, exception occurred');
    //     debugPrint(error.toString());
    //     completer.completeError(error);
    //   });
    // } catch (e) {
    //   debugPrint('Connecting to device $deviceId resulted in error $e');
    //   if (!completer.isCompleted) {
    //     completer.completeError(e);
    //   }
    // }
    //
    // return completer.future.timeout(const Duration(seconds: 10),
    //     onTimeout: () => throw TimeoutException('Connection timeout'));
  }

  Stream<BluetoothDiscoveryResult> _startScan() {
    return bluetooth.startDiscovery();
  }

  @override
  Future<void> stopScan() async {
    await bluetooth.cancelDiscovery();
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }
}
