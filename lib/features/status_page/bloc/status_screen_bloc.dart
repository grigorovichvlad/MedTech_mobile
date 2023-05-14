import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'status_screen_event.dart';

part 'status_screen_state.dart';

class DevicesListBloc extends Bloc<StatusScreenEvent, StatusScreenState> {
  DevicesListBloc(this.devicesRepository) : super(StatusScreenInitial()) {
    on<LoadStatusScreen>((event, emit) async {});
  }

  final AbstractBluetoothRepository devicesRepository;
}
