import 'dart:async';
import 'package:flutter/cupertino.dart';
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

  DevicesListBloc(this.devicesRepository) : super(DevicesListInitial()) {
    on<LoadDevicesList>((event, emit) async {
      emit(DevicesListLoading());

      List<PermissionStatus> status = [
        await Permission.bluetoothConnect.status,
        await Permission.bluetooth.status,
        await Permission.location.status, // нужно будет вернуть в AndroidManifest
        await Permission.bluetoothScan.status,
      ];

      if (status[0].isDenied || /* status[1].isDenied ||*/ status[1].isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
      }

      devicesRepository.scanForDevices(this);
      event.completer?.complete();
    });

    on<SetDevicesList>((event, emit) {
      emit(DevicesListInitial());
      emit(DevicesListLoaded(devicesList: event.devicesList));
    });

    on<LoadingFalure>((event, emit) {
      if (event.status is BleStatus) {
        BleStatus StatusIOS = event.status as BleStatus;
        emit(DevicesListLoadingFailure(
            status: StatusIOS.toString(),
            exception: event.exception.toString()
        ));
      } else if (event.status is BluetoothState) {
        BluetoothState StatusAndroid = event.status as BluetoothState;
        emit(DevicesListLoadingFailure(
            status: StatusAndroid.toString(),
            exception: event.exception.toString()
        ));
      } else {
        emit(DevicesListLoadingFailure(
            status: 'Unknowne',// тут попа нам
            exception: event.exception.toString()
        ));
      }
    });


    on<ConnectDevice>((event, emit) async {
      await devicesRepository.stopScan();
      await devicesRepository.connect(event.id!);
      emit(DeviceConnecting());
      await event.onSubmit();
      event.completer?.complete();
    });
  }
}
