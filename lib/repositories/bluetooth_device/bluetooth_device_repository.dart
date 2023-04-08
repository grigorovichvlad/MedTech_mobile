import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  BluetoothDeviceRepository({required this.ble});

  final FlutterReactiveBle ble;
  final List<BluetoothDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;
  late StreamSubscription<ConnectionStateUpdate> _connection;

  @override
  Future<List<BluetoothDevice>> scanForDevices() async {
    await scan();

    debugPrint(bluetoothDevices.toString());
    return bluetoothDevices;
  }

  Future<void> scan() async {
    const scanDuration = Duration(seconds: 4);
    _startScan();

    _scanSubscription = ble.statusStream.listen((status) {
      if (status == BleStatus.ready) {
        _startScan().listen((device) {
          if (device.name.isNotEmpty) {
            debugPrint(device.name.toString());
            final bluetoothDevice = BluetoothDevice(
              name: device.name,
              id: device.id,
            );
            bluetoothDevices.add(bluetoothDevice);
          }
        });
      }
    });

    await Future.delayed(scanDuration);
    await stopScan();
  }

  Stream<DiscoveredDevice> _startScan() {
    const scanMode = ScanMode.lowLatency;
    const scanForAndroidOnlyServices = false;
    return ble.scanForDevices(
      withServices: [],
      scanMode: scanMode,
    );
  }

  @override
  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  @override //Не проверял
  Future<void> connect(String deviceId) {
    _connection = ble.connectToDevice(id: deviceId).listen(
      (update)
      {
            debugPrint('ConnectionState for device $deviceId : ${update.connectionState}');
      },
      onError: (Object e) =>
          debugPrint('Connecting to device $deviceId resulted in error $e'),
    );
    throw UnimplementedError();
  }
}
