//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

abstract class AbstractBluetoothRepository{
  Future<void> stopScan();
  void scanForDevices(DevicesListBloc devicesListBloc);
  Future<void> connect(String? deviceId);
}