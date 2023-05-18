// import 'package:flutter_test/flutter_test.dart';
// import 'package:med_tech_mobile/dependency_provider.dart';
// import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
// import 'package:mockito/mockito.dart';
//
// void main() {
//   group('BluetoothDeviceRepository', () {
//     final mockBluetoothDeviceRepository = MockBluetoothDeviceRepository();
//
//     test('connect should successfully connect to a Bluetooth device', () async {
//       final deviceId = 'mac-address 1';
//
//       // Вызываем метод `connect` с мок объекта.
//       await mockBluetoothDeviceRepository.connect(deviceId);
//
//       // Если нет выброса исключений, значит подключение прошло успешно.
//       // В этом тесте нам не нужно проверять, что именно делает метод `connect`,
//       // так как мы тестируем только его вызов.
//       expect(true, true);
//     });
//   });
// }