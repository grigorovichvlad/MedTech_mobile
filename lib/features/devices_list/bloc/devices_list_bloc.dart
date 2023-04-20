import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'devices_list_event.dart';

part 'devices_list_state.dart';

class DevicesListBloc extends Bloc<DevicesListEvent, DevicesListState> {
  DevicesListBloc(this.devicesRepository) : super(DevicesListInitial()) {

    on<LoadDevicesList>((event, emit) async {
        emit(DevicesListLoading());

        List<PermissionStatus> status = [
          await Permission.bluetoothConnect.status,
          await Permission.location.status,
          await Permission.bluetoothScan.status,
        ];
        if (status[0].isPermanentlyDenied || status[1].isPermanentlyDenied || status[2].isPermanentlyDenied) {
          openAppSettings();
        }
        if (status[0].isDenied || status[1].isDenied || status[2].isDenied) {
          // We didn't ask for permission yet or the permission has been denied before but not permanently.
          Map<Permission, PermissionStatus> statuses = await [
            Permission.location,
            Permission.bluetoothScan,
            Permission.bluetoothConnect,
          ].request();
          debugPrint(statuses[Permission.location].toString());
          debugPrint(statuses[Permission.bluetoothScan].toString());
          debugPrint(statuses[Permission.bluetoothConnect].toString());
        }

        devicesRepository.scanForDevices(this);
        event.completer?.complete();
    });

    on<SetDevicesList>((event, emit) {
        emit(DevicesListInitial());
        emit(DevicesListLoaded(devicesList: event.devicesList));
    });

    on<LoadingFalure>((event, emit) {
      emit(DevicesListLoadingFailure(status: event.status.name, exception: event.exception.toString()));
    });

    on<ConnectDevice>((event, emit) async {
      await devicesRepository.connect(event.id!);
      emit(DeviceConnecting());
      return;
    });

    }

  final AbstractBluetoothRepository devicesRepository;
}

