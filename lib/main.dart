import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/theme/theme.dart';
import 'package:med_tech_mobile/router/router.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton(BluetoothDeviceRepository(ble: FlutterReactiveBle()));
  runApp(
    MaterialApp(
      theme: defaultTheme,
      initialRoute: '/',
      routes: routers,
    )
  );
}