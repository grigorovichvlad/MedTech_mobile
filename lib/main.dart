import 'package:flutter/material.dart';
import 'package:med_tech_mobile/presenters/bluetooth_devices.dart';
import 'package:med_tech_mobile/presenters/login.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => Login(),
        '/devices' : (context) => BluetoothDevices(),
      },
    )
  );
}