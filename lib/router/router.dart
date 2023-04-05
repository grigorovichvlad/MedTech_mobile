import 'package:med_tech_mobile/features/devices_list/device_list.dart';
import 'package:med_tech_mobile/features/login/login.dart';

final routers = {
  '/' : (context) => Login(),
  '/devices' : (context) => BluetoothDevices(),
};