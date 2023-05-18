import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:mockito/mockito.dart';

import 'features/devices_list/bloc/devices_list_bloc.dart';

class MockBluetoothDeviceRepository extends Mock implements BluetoothDeviceRepository {
  final List<MedTechDevice> _bluetoothDevices = [];

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
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
  FlutterBluePlus get bluetooth => throw UnimplementedError();
}


BluetoothDeviceRepository createBluetoothRepository({required bool isTesting}) {
  if (isTesting) {
    return MockBluetoothDeviceRepository();
  } else {
    return BluetoothDeviceRepository(bluetooth: FlutterBluePlus.instance);
  }
}
