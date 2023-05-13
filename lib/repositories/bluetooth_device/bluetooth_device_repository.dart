import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.ble});

  final FlutterReactiveBle ble;
  final List<BluetoothDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;
  late StreamSubscription<ConnectionStateUpdate> _connection;

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
    bluetoothDevices.clear();
    _scanSubscription?.cancel();
    _scanSubscription = _startScan().listen((device) {
      final indexOfDevice =
          bluetoothDevices.indexWhere((d) => (device.id == d.id));
      if (indexOfDevice < 0) {
        final bluetoothDevice = BluetoothDevice(
          name: device.name,
          id: device.id,
        );
        bluetoothDevices.add(bluetoothDevice);
        devicesListBloc.add(SetDevicesList(bluetoothDevices));
      } else {
        bluetoothDevices[indexOfDevice] =
            BluetoothDevice(name: device.name, id: device.id);
      }
    }, onError: (error)
    {
      devicesListBloc.add(LoadingFalure(status: ble.status, exception: error));
    });
  }

  @override
  Future<void> connect(String? deviceId) {
    final completer = Completer<void>();

    debugPrint('Connecting to $deviceId');
    _connection = ble.connectToDevice(id: deviceId!).listen(
      (update) {
        debugPrint(
            'ConnectionState for device $deviceId : ${update.connectionState}');
        if (update.connectionState == DeviceConnectionState.connected &&
            !completer.isCompleted) {
          completer.complete();
        }
      },
      onError: (Object e) {
        debugPrint('Connecting to device $deviceId resulted in error $e');
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
    );

    return completer.future.timeout(const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Время подключения закончено'));
  }

  Stream<DiscoveredDevice> _startScan() {
    const scanMode = ScanMode.lowLatency;
    return ble.scanForDevices(
      withServices: [],
      scanMode: scanMode,
    );
  }

  @override
  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }
}
