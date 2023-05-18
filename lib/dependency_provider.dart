// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
// import 'package:mockito/mockito.dart';
//
// import 'features/devices_list/bloc/devices_list_bloc.dart';
//
// class MockBluetoothDeviceRepository extends Mock implements BluetoothDeviceRepository {
//   final List<BluetoothDeviceMy> _bluetoothDevices = [];
//
//   @override
//   void scanForDevices(DevicesListBloc devicesListBloc) {
//     _bluetoothDevices.clear();
//     _bluetoothDevices.addAll([
//       BluetoothDeviceMy(
//         name: 'Test Device 1',
//         id: 'mac-address 1',
//       ),
//       BluetoothDeviceMy(
//         name: 'Test Device 2',
//         id: 'mac-address 2',
//       ),
//     ]);
//     devicesListBloc.add(SetDevicesList(bluetoothDevices));
//   }
//
//   @override
//   List<BluetoothDeviceMy> get bluetoothDevices => _bluetoothDevices;
//
//   @override
//   Future<void> stopScan() async {
//   }
//
//   @override
//   Future<void> connect(String? deviceId) {
//     debugPrint('Подключение успешно');
//     return Future.value();
//   }
//
//   @override
//   FlutterReactiveBle get ble => throw UnimplementedError();
// }
//
//
// BluetoothDeviceRepository createBluetoothRepository({required bool isTesting}) {
//   if (isTesting) {
//     return MockBluetoothDeviceRepository();
//   } else {
//     return BluetoothDeviceRepository(ble: FlutterReactiveBle());
//   }
// }
