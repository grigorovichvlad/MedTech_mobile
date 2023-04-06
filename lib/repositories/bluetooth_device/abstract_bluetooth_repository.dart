import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

abstract class AbstractBluetoothRepository{
  Future<List<BluetoothDevice>> scanForDevices();
}