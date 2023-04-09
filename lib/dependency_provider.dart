import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:mockito/mockito.dart';

class MockBluetoothDeviceRepository extends Mock implements BluetoothDeviceRepository {
  final List<BluetoothDevice> _bluetoothDevices = [];

  @override
  Future<List<BluetoothDevice>> scanForDevices() async {
    await Future.delayed(const Duration(seconds: 4));
    _bluetoothDevices.clear();
    _bluetoothDevices.addAll([
      BluetoothDevice(
        name: 'Test Device 1',
        id: 'mac-address 1',
      ),
      BluetoothDevice(
        name: 'Test Device 2',
        id: 'mac-address 2',
      ),
    ]);
    return _bluetoothDevices;
  }

  @override
  List<BluetoothDevice> get bluetoothDevices => _bluetoothDevices;

  @override
  Future<void> stopScan() async {
  }

  @override
  Future<void> connect(String? deviceId) {
    return Future.value();
  }

  @override
  FlutterReactiveBle get ble => throw UnimplementedError();
}


BluetoothDeviceRepository createBluetoothRepository({required bool isTesting}) {
  if (isTesting) {
    return MockBluetoothDeviceRepository();
  } else {
    return BluetoothDeviceRepository(ble: FlutterReactiveBle());
  }
}
