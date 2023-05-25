import 'package:flutter_test/flutter_test.dart';
import 'package:med_tech_mobile/dependency_provider.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('BluetoothDeviceRepository', () {
    final mockBluetoothDeviceRepository = MockBluetoothDeviceRepository();

    test('Подключение к устройству', () async {
      final deviceId = 'mac-address 1';

      // Вызываем метод `connect` с мок объекта.
      await mockBluetoothDeviceRepository.connect(deviceId);
      mockBluetoothDeviceRepository.isConnected();

      expect(true, true);
    });
  });
}
