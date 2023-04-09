import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/theme/theme.dart';
import 'package:med_tech_mobile/router/router.dart';
import 'dependency_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // final bluetoothRepository = createBluetoothRepository(isTesting: false);
  GetIt.I.registerSingleton(BluetoothDeviceRepository(ble: FlutterReactiveBle()));
  runApp(
    MaterialApp(
      theme: defaultTheme,
      initialRoute: '/',
      routes: routers,
    ),
  );
}
