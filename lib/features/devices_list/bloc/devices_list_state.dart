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
  DevicesListLoaded({required this.devices_list});
  final List<BluetoothDevice> devices_list;

  @override
  List<Object?> get props => [devices_list];
}

class DevicesListLoadingFailure extends DevicesListState {
  DevicesListLoadingFailure({required this.exception});
  final Object? exception;

  @override
  List<Object?> get props => [exception];
}

