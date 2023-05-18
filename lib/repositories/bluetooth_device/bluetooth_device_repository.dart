import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.bluePlus});

  final FlutterBluePlus bluePlus;
  final List<BluetoothDevice> bluetoothDevices = [];

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
    bluetoothDevices.clear();
    bluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        BluetoothDevice device = result.device;
        final indexOfDevice =
        bluetoothDevices.indexWhere((d) => (device.id == d.id));
        if (indexOfDevice < 0 && device.name.isNotEmpty) {
          final bluetoothDevice = BluetoothDeviceMy(
            name: device.name,
            id: device.id.toString(),
          );
          bluetoothDevices.add(bluetoothDevice as BluetoothDevice);
          devicesListBloc.add(SetDevicesList(bluetoothDevice as List<BluetoothDeviceMy>));
        } else if (device.name.isNotEmpty) {
          bluetoothDevices[indexOfDevice] =
          BluetoothDeviceMy(name: device.name, id: device.id.toString()) as BluetoothDevice;
        }
      }
    }, onError: (error)
    {
      devicesListBloc.add(LoadingFalure(status: BluetoothState.off, exception: error));
    });

    bluePlus.startScan();
  }

  @override
  Future<void> connect(String? deviceId) async {
    debugPrint('Connecting to $deviceId');
    List<BluetoothDevice> connectedDevices = await bluePlus.connectedDevices;
    BluetoothDevice device = connectedDevices.firstWhere((device) => device.id.toString() == deviceId);
    await device.connect(autoConnect: false).timeout(const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Время подключения закончено'));
  }

  @override
  Future<void> stopScan() async {
    await bluePlus.stopScan();
  }
}

