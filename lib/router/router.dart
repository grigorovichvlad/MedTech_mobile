import 'package:med_tech_mobile/features/devices_list/device_list.dart';
import 'package:med_tech_mobile/features/login/login.dart';
import 'package:med_tech_mobile/features/status_page/status_screen.dart';

final routers = {
  '/' : (context) => Login(),
  '/devices' : (context) => BluetoothDevices(),
  // '/status' : (context) => StatusScreen(),
};