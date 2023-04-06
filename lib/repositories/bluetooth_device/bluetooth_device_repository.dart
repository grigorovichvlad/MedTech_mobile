import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository{

  BluetoothDeviceRepository({required this.ble});

  final FlutterReactiveBle ble;// = FlutterReactiveBle();

  @override
  Future<List<BluetoothDevice>> scanForDevices() async {

    // UUID сервиса и характеристики, которые вам нужны для работы с BLE
    const serviceUuid = 'your-service-uuid';
    const characteristicUuid = 'your-characteristic-uuid';

    final devices = ble.scanForDevices(
      withServices: [Uuid.parse(serviceUuid)],
      scanMode: ScanMode.lowLatency,
    );

    final List<BluetoothDevice> bluetoothDevices = [];

    await for (final device in devices) {
      if (device.name.isNotEmpty) {
        final bluetoothDevice = BluetoothDevice(
          name: device.name,
        );
        bluetoothDevices.add(bluetoothDevice);
      }
    }
    // TODO: Верните список с полученными данными
    return bluetoothDevices;
   // throw UnimplementedError();
  }

      //debugPrint('Found device: ${device.name} (${device.id})');
      //debugPrint('Error occurred while scanning: $error');

}
