import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bluePlus;
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.flutterBlue});

  final bluePlus.FlutterBluePlus flutterBlue;
  final List<BluetoothDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;

  @override
  void scanForDevices(DevicesListBloc devicesListBloc) {
    bluetoothDevices.clear();
    _scanSubscription?.cancel();
    _scanSubscription = flutterBlue.scan().listen((scanResult) {
      final device = scanResult.device;
      final indexOfDevice =
      bluetoothDevices.indexWhere((d) => (device.id == d.id));
      if (indexOfDevice < 0 && device.name.isNotEmpty) {  // check if device name is not empty
        final bluetoothDevice = BluetoothDevice(
          name: device.name,
          id: device.id.toString(),
        );
        bluetoothDevices.add(bluetoothDevice);
        devicesListBloc.add(SetDevicesList(bluetoothDevices));
      } else if (device.name.isNotEmpty) {  // check if device name is not empty
        bluetoothDevices[indexOfDevice] =
            BluetoothDevice(name: device.name, id: device.id.toString());
      }
    }, onError: (error)
    {
      devicesListBloc.add(LoadingFalure(status: bluePlus.BluetoothState.off, exception: error));
    });
  }


  @override
  Future<void> connect(String? deviceId) {
    final completer = Completer<void>();

    debugPrint('Connecting to $deviceId');

    _scanSubscription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.id == deviceId) {
        _scanSubscription?.cancel();

        scanResult.device.connect().then((_) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }).catchError((error) {
          debugPrint('Connecting to device $deviceId resulted in error $error');
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        });
      }
    });

    return completer.future.timeout(const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Время подключения закончено'));
  }


  @override
  Future<void> stopScan() async {
    await flutterBlue.stopScan();
    _scanSubscription?.cancel();
    _scanSubscription = null;
  }
}
