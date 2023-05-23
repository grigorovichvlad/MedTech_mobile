import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'devices_list_event.dart';
part 'devices_list_state.dart';

class DevicesListBloc extends Bloc<DevicesListEvent, DevicesListState> {
  final AbstractBluetoothRepository devicesRepository;
  int devicesCount = 0;

  DevicesListBloc(this.devicesRepository) : super(DevicesListInitial()) {
    on<LoadDevicesList>((event, emit) async {
      emit(DevicesListLoading());
      devicesCount = 0;

      List<PermissionStatus> status = [
        await Permission.location.status,
        await Permission.bluetoothConnect.status,
        await Permission.bluetooth.status,
        await Permission.bluetoothScan.status,
      ];

      if (status[0].isDenied ||
          status[1].isDenied ||
          status[2].isDenied ||
          status[3].isDenied) {
        await [
          Permission.location,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.bluetooth,
        ].request();
      }

      status = [
        await Permission.location.status,
        await Permission.bluetoothConnect.status,
        await Permission.bluetooth.status,
        await Permission.bluetoothScan.status,
      ];

      bool? isBluetoothOn = await FlutterBluetoothSerial.instance.isEnabled;
      if (isBluetoothOn == false) {
        add(LoadingFalure(code: 1, exception: Exception('Bluetooth is off')));
        return;
      }

      if (!status[0].isGranted ||
          !status[1].isGranted ||
          !status[2].isGranted ||
          !status[3].isGranted) {
        add(LoadingFalure(
            code: 3, exception: Exception('Permissions are missing')));
        return;
      }

      await devicesRepository.stopScan();
      try {
        devicesRepository.scanForDevices(this, () async {
          List<PermissionStatus> status = [
            await Permission.location.status,
            await Permission.bluetoothConnect.status,
            await Permission.bluetooth.status,
            await Permission.bluetoothScan.status,
          ];

          bool? isBluetoothOn = await FlutterBluetoothSerial.instance.isEnabled;

          if (status[0].isDenied ||
              status[1].isDenied ||
              status[2].isDenied ||
              status[3].isDenied ||
              (isBluetoothOn == false)) {
            add(LoadDevicesList());
          }

          if (devicesCount == 0) {
            add(LoadingFalure(code: 667, exception: Exception('There are no devices')));
          }
        });
      } catch (error) {
        add(LoadingFalure(code: 777, exception: Exception('Unknown')));
      }

      event.completer?.complete();
    });

    on<SetDevicesList>((event, emit) {
      emit(DevicesListInitial());
      devicesCount = event.devicesList.length;
      emit(DevicesListLoaded(devicesList: event.devicesList));
    });

    on<LoadingFalure>((event, emit) {
      /// code 1 = Bluetooth is off
      /// code 3 = Not all permissions available
      /// code 667 = There are no available devices
      /// code 777 = Unknown error
      if (event.code is BleStatus) {
        BleStatus statusIOS = event.code as BleStatus;
        emit(DevicesListLoadingFailure(
            code: statusIOS.toString(), exception: event.exception.toString()));
      } else if (event.code is int) {
        int statusCode = event.code as int;
        emit(DevicesListLoadingFailure(
            code: statusCode, exception: event.exception.toString()));
      } else {
        emit(DevicesListLoadingFailure(
            code: 777, // тут попа нам
            exception: event.exception.toString()));
      }
    });

    on<ConnectDevice>((event, emit) async {
      await devicesRepository.stopScan();
      try {
        await devicesRepository
            .connect(event.id)
            .timeout(const Duration(seconds: 5), onTimeout: () {
          throw TimeoutException('Connection timeout.');
          return;
        });
      } catch (error) {
        event.closeDialog();
        throw TimeoutException('ERROR');
      }
      event.closeDialog();
      if (devicesRepository.isConnected()) {
        await event.onSubmit();
      }
      event.completer?.complete();
    });
  }
}
