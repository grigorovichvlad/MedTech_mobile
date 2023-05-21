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
  final List<MedTechDevice> devicesList;

  @override
  List<Object?> get props => [devicesList];
}

class DevicesListLoadingFailure extends DevicesListState {
  DevicesListLoadingFailure({required this.status, required this.exception});
  final String exception;
  final String status;

  @override
  List<Object?> get props => [exception, status];
}

class DeviceConnecting extends DevicesListState {
  @override
  List<Object?> get props => [];
}

class DeviceConnected extends DevicesListState {
  @override
  List<Object?> get props => [];
}