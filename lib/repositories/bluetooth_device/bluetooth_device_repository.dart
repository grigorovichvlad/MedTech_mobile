import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {

  BluetoothDeviceRepository({required this.ble});

  final FlutterReactiveBle ble; // = FlutterReactiveBle();
  StreamSubscription? _scanSubscription; // Подписка на события сканирования

  @override
  Future<List<BluetoothDevice>> scanForDevices() async {
    final List<BluetoothDevice> bluetoothDevices = [];

    final scanResult = _startScan();

    const scanDuration = Duration(seconds: 10); // Длительность сканирования
    _scanSubscription = scanResult.take(scanDuration.inSeconds).listen((device) {
      if (device.name.isNotEmpty) { // Если имя устройства не пустое, добавляем его в список
        final bluetoothDevice = BluetoothDevice(
          //id: device.id,
          name: device.name,
        );
        bluetoothDevices.add(bluetoothDevice);
      }
    });

    await stopScan();

    return bluetoothDevices;
  }

  Stream<DiscoveredDevice> _startScan() {
    const scanMode = ScanMode.lowLatency; // Режим сканирования с низкой задержкой
    const scanForAndroidOnlyServices = false;
    return ble.scanForDevices(
      withServices: [], // Сканирование всех доступных служб
      scanMode: scanMode,
      //requireLocationServicesEnabled: true, // Требование включенных служб геолокации.ХЗ надо или нет
    );
  }

  @override
  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null; // Обнуление подписки
  }

    //     //debugPrint('Found device: ${device.name} (${device.id})');
    //     //debugPrint('Error occurred while scanning: $error');

  }
