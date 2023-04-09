part of 'devices_list_bloc.dart';

abstract class DevicesListState extends Equatable{}

class DevicesListInitial extends DevicesListState {
  @override
  List<Object?> get props => [];
}

class DevicesListLoading extends DevicesListState {
  @override
  List<Object?> get props => [];
}

class DevicesListLoaded extends DevicesListState {
  DevicesListLoaded({required this.devicesList});
  final List<BluetoothDevice> devicesList;

  @override
  List<Object?> get props => [devicesList];
}

class DevicesListLoadingFailure extends DevicesListState {
  DevicesListLoadingFailure({required this.exception});
  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

class DeviceConnecting extends DevicesListState {
  @override
  List<Object?> get props => [];
}