import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/dependency_provider.dart';
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
        // await Permission.location.status, //Если раскомментить, то будет говорить, что разрешения не дано
        await Permission.bluetoothConnect.status,
        await Permission.bluetooth.status,
        await Permission.bluetoothScan.status,
      ];

      if (status[0].isDenied || status[1].isDenied || status[2].isDenied /*|| status[3].isDenied*/) {
        await [ // Запрос прав
          // Permission.location,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.bluetooth,
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
        BleStatus statusIOS = event.status as BleStatus;
        emit(DevicesListLoadingFailure(
            status: statusIOS.toString(),
            exception: event.exception.toString()));
      } else if (event.status is BluetoothState) {
        BluetoothState statusAndroid = event.status as BluetoothState;
        emit(DevicesListLoadingFailure(
            status: statusAndroid.toString(),
            exception: event.exception.toString()));
      } else {
        emit(DevicesListLoadingFailure(
            status: 'Unknown', // тут попа нам
            exception: event.exception.toString()));
      }
    });

    on<ConnectDevice>((event, emit) async {
      await devicesRepository.stopScan();
      try {
        await devicesRepository.connect(event.id);
      }
      catch (error) {
        debugPrint("ERROR");
      }
      event.closeDialog();
      if (devicesRepository.isConnected()) {
        await event.onSubmit();
      }
      event.completer?.complete();
    });
  }
}
