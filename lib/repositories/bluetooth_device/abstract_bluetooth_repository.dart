import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

abstract class AbstractBluetoothRepository{
  Future<void> stopScan();
  Future<void> disconnect();
  void listenForData(void Function(Uint8List) onData);
  StreamSubscription<BluetoothState>? listenForState(void Function(BluetoothState) onData);
  void scanForDevices(DevicesListBloc devicesListBloc, void Function() onDone);
  Future<void> connect(String? deviceId);
  bool isConnected();
}