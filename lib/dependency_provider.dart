import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mockito/mockito.dart';

import 'features/devices_list/bloc/devices_list_bloc.dart';

class MockBluetoothDeviceRepository extends Mock implements BluetoothDeviceRepository {
  final List<MedTechDevice> _bluetoothDevices = [];

  @override
  void scanForDevices(DevicesListBloc devicesListBloc, void Function() onDone) {
    _bluetoothDevices.clear();
    _bluetoothDevices.addAll([
      MedTechDevice(
        name: 'Test Device 1',
        id: 'mac-address 1',
      ),
      MedTechDevice(
        name: 'Test Device 2',
        id: 'mac-address 2',
      ),
    ]);
    devicesListBloc.add(SetDevicesList(bluetoothDevices));
  }

  @override
  List<MedTechDevice> get bluetoothDevices => _bluetoothDevices;

  @override
  Future<void> stopScan() async {
  }

  @override
  Future<void> connect(String? deviceId) {
    debugPrint('Подключение успешно');
    return Future.value();
  }

  @override
  bool isConnected() {
    return true;
  }

  @override
  FlutterReactiveBle get ble => throw UnimplementedError();
}



BluetoothDeviceRepository createBluetoothRepository({required bool isTesting}) {
  if (isTesting) {
    return MockBluetoothDeviceRepository();
  } else {
    return BluetoothDeviceRepository(ble: FlutterReactiveBle(), bluetooth: FlutterBluetoothSerial.instance);
  }
}
