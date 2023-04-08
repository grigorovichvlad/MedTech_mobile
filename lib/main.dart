import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/theme/theme.dart';
import 'package:med_tech_mobile/router/router.dart';
import 'dependency_provider.dart';

void main() {
  final bluetoothRepository = createBluetoothRepository(isTesting: true);
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<BluetoothDeviceRepository>(bluetoothRepository);
  runApp(
    MaterialApp(
      theme: defaultTheme,
      initialRoute: '/',
      routes: routers,
    ),
  );
}
