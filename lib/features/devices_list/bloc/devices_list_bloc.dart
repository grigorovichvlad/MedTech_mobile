import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'devices_list_event.dart';

part 'devices_list_state.dart';

class DevicesListBloc extends Bloc<DevicesListEvent, DevicesListState> {
  DevicesListBloc(this.devicesRepository) : super(DevicesListInitial()) {

    on<LoadDevicesList>((event, emit) {
        emit(DevicesListLoading());

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

