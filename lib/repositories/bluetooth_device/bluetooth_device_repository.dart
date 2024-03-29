import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import '../../features/devices_list/bloc/devices_list_bloc.dart';

class BluetoothDeviceRepository implements AbstractBluetoothRepository {
  final FlutterBluetoothSerial? bluetooth;
  final FlutterReactiveBle? ble;

  BluetoothDeviceRepository({this.bluetooth, this.ble}) {
    if (Platform.isIOS && ble == null) {
      throw ArgumentError('ble cant be null on IOS');
    }

    if (Platform.isAndroid && bluetooth == null) {
      throw ArgumentError('bluetooth cant be null on Android');
    }
  }

  final List<MedTechDevice> bluetoothDevices = [];
  StreamSubscription? _scanSubscription;

  late StreamSubscription<ConnectionStateUpdate> _connectionIOS;
  BluetoothConnection? _connectionAndroid;

  @override
  void scanForDevices(DevicesListBloc devicesListBloc, void Function() onDone) {
    if (Platform.isIOS) {
      bluetoothDevices.clear();
      _scanSubscription?.cancel();
      _scanSubscription = _startScanIOS().listen((device) {
        final indexOfDevice =
            bluetoothDevices.indexWhere((d) => (device.id == d.id));
        if (indexOfDevice < 0 && device.name.isNotEmpty) {
          // проверяем, что имя устройства не пустое
          final bluetoothDevice = MedTechDevice(
            name: device.name,
            id: device.id,
          );
          bluetoothDevices.add(bluetoothDevice);
          devicesListBloc.add(SetDevicesList(bluetoothDevices));
        } else if (device.name.isNotEmpty) {
          // проверяем, что имя устройства не пустое
          bluetoothDevices[indexOfDevice] =
              MedTechDevice(name: device.name, id: device.id);
        }
      }, onError: (error) {
        devicesListBloc.add(LoadingFalure(code: ble!.status, exception: error));
      });
    } else if (Platform.isAndroid) {
      debugPrint('scanForDevices: Starting...');
      bluetoothDevices.clear();
      _scanSubscription?.cancel();
      _scanSubscription = _startScanAndroid().listen((result) {
        BluetoothDevice device = result.device;
        debugPrint(
            'scanForDevices: Discovered ${device.name} (${device.address})');
        final indexOfDevice =
            bluetoothDevices.indexWhere((d) => (device.address == d.id));
        if (indexOfDevice < 0 &&
            device.name != null &&
            device.name!.isNotEmpty) {
          debugPrint('scanForDevices: Adding new device ${device.name}');
          final medTechDevice = MedTechDevice(
            name: device.name ?? '',
            id: device.address,
          );
          bluetoothDevices.add(medTechDevice);
          devicesListBloc.add(SetDevicesList(bluetoothDevices));
        } else if (device.name != null && device.name!.isNotEmpty) {
          debugPrint('scanForDevices: Updating existing device ${device.name}');
          bluetoothDevices[indexOfDevice] =
              MedTechDevice(name: device.name ?? '', id: device.address);
        }
      }, onDone: () async {
        onDone();
        debugPrint('scanForDevices: Discovering is done.');
      });
    }
  }

  @override
  void listenForData(
    void Function(Uint8List) onData,
      void Function() onDone,
  ) {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      _connectionAndroid?.input?.listen((Uint8List characters) {
        onData(characters);
      }, onDone: () {
        onDone();
      });
    }
  }

  @override
  StreamSubscription<BluetoothState>? listenForState(
      void Function(BluetoothState) onData) {
    if (Platform.isIOS) {
      return null;
    } else if (Platform.isAndroid) {
      return bluetooth?.onStateChanged().listen((state) {
        onData(state);
      });
    }
    return null;
  }

  @override
  Future<void> connect(String? deviceId) async {
    if (Platform.isIOS) {
      final completer = Completer<void>();

      debugPrint('Connecting to $deviceId');
      _connectionIOS = ble!.connectToDevice(id: deviceId!).listen(
        (update) {
          debugPrint(
              'ConnectionState for device $deviceId : ${update.connectionState}');
          if (update.connectionState == DeviceConnectionState.connected &&
              !completer.isCompleted) {
            completer.complete();
          }
        },
        onError: (Object e) {
          debugPrint('Connecting to device $deviceId resulted in error $e');
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },
      );

      return completer.future.timeout(const Duration(seconds: 10),
          onTimeout: () =>
              throw TimeoutException('Время подключения закончено'));
    } else if (Platform.isAndroid) {
      final completer = Completer<void>();

      if (deviceId == null) {
        debugPrint('DeviceId is null');
        completer.completeError(Exception('DeviceId is null'));
        return completer.future;
      }

      debugPrint('Connecting to $deviceId');

      try {
        _connectionAndroid = await BluetoothConnection.toAddress(deviceId);
        debugPrint('Connected to the $deviceId');
        completer.complete();
      } catch (e) {
        debugPrint('Connecting to device $deviceId resulted in error $e');
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }

      return completer.future.timeout(const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException('Connection timeout'));
    }
  }

  Stream<DiscoveredDevice> _startScanIOS() {
    const scanMode = ScanMode.lowLatency;
    return ble!.scanForDevices(
      withServices: [],
      scanMode: scanMode,
    );
  }

  Stream<BluetoothDiscoveryResult> _startScanAndroid() {
    return bluetooth!.startDiscovery();
  }

  @override
  Future<void> stopScan() async {
    if (Platform.isIOS) {
      await _scanSubscription?.cancel();
    } else if (Platform.isAndroid) {
      if (await FlutterBluetoothSerial.instance.isDiscovering ?? false) {
        await bluetooth?.cancelDiscovery();
        _scanSubscription?.cancel();
      }
    }
    _scanSubscription = null;
  }

  @override
  Future<void> disconnect() async {
    if (Platform.isIOS) {
      //TODO: aboba
    } else if (Platform.isAndroid) {
      // if (_connectionAndroid?.isConnected ?? false) {
      await _connectionAndroid?.finish(); // Closing connection
      _connectionAndroid = null;
      debugPrint('Disconnecting by local host');
      // }
    }
  }

  @override
  bool isConnected() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      return _connectionAndroid?.isConnected ?? false;
    }
    return false;
  }

  @override
  bool? disconnectionSource() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      return _connectionAndroid?.isConnected; // null - by remote; false - by host; true - not disconnected
    }
    return false;
  }
}
