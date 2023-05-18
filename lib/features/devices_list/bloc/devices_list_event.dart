part of 'devices_list_bloc.dart';

abstract class DevicesListEvent extends Equatable{
  get completer => null;
}

class LoadDevicesList extends DevicesListEvent{
  LoadDevicesList({this.completer});
  final Completer? completer;

  @override
  List<Object?> get props => [completer];
}

class LoadingFalure extends DevicesListEvent{
  LoadingFalure({required this.status, required this.exception});
  final Exception exception;
  final BluetoothState status;

  @override
  List<Object?> get props => [exception, status];
}

class SetDevicesList extends DevicesListEvent{
  SetDevicesList(this.devicesList);
  final List<BluetoothDeviceMy> devicesList;

  @override
  List<Object?> get props => [completer, devicesList];
}

class ConnectDevice extends DevicesListEvent{
  ConnectDevice({
    this.completer,
    required this.id,
    required this.onSubmit,
  });
  final Completer? completer;
  final String id;
  final Function onSubmit;

  @override
  List<Object?> get props => [completer, id];
}