import 'dart:async';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'devices_list_event.dart';
part 'devices_list_state.dart';

class DevicesListBloc extends Bloc<DevicesListEvent, DevicesListState> {
  DevicesListBloc(this.devicesRepository) : super(DevicesListInitial()) {

    on<DevicesListEvent>((event, emit) async {
      if (state is DevicesListLoaded){
        emit(DevicesListLoading());
      }
      final DevicesList = await devicesRepository.scanForDevices();
      emit(DevicesListLoaded(devices_list: DevicesList));
    });
  }

  final AbstractBluetoothRepository devicesRepository;
}
