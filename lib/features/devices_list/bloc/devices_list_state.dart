part of 'devices_list_bloc.dart';

abstract class DevicesListState {}

class DevicesListInitial extends DevicesListState {}

class DevicesListLoading extends DevicesListState {}

class DevicesListLoaded extends DevicesListState {
  DevicesListLoaded({required this.devices_list});
  final List<BluetoothDevice> devices_list;
}

class DevicesListLoadingFailure extends DevicesListState {}

