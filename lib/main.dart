import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/DB_isolate_repository/db_isolate_repository.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';
import 'package:med_tech_mobile/theme/theme.dart';
import 'package:med_tech_mobile/router/router.dart';
import 'dependency_provider.dart';
import 'dart:isolate';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final bluetoothRepository = createBluetoothRepository(
      isTesting: false); // true - test on, false test off
  GetIt.I.registerSingleton<BluetoothDeviceRepository>(
      bluetoothRepository /*BluetoothDeviceRepository(ble: FlutterReactiveBle())*/);
  GetIt.I.registerSingleton<DBIsolateRepository>(DBIsolateRepository());
  runApp(
    MaterialApp(
      theme: defaultTheme,
      initialRoute: '/',
      routes: routers,
    ),
  );
}
