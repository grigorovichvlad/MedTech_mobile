import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

abstract class AbstractBluetoothRepository{
  Future<List<BluetoothDevice>> scanForDevices();
  Future<void> stopScan();
  Stream<DiscoveredDevice> _startScan();
  Future<void> connect(String deviceId);
}