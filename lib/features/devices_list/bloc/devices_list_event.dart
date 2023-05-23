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
  LoadingFalure({required this.code, required this.exception});
  final Exception exception;
  final Object code;

  @override
  List<Object?> get props => [exception, code];
}

class SetDevicesList extends DevicesListEvent{
  SetDevicesList(this.devicesList);
  final List<MedTechDevice> devicesList;

  @override
  List<Object?> get props => [completer, devicesList];
}

class DialogShow extends DevicesListEvent {
  DialogShow();

  @override
  List<Object?> get props => [];
}

class ConnectDevice extends DevicesListEvent{
  ConnectDevice({
    this.completer,
    required this.id,
    required this.onSubmit,
    required this.closeDialog,
  });
  final Completer? completer;
  final String id;
  final Function onSubmit;
  final Function closeDialog;

  @override
  List<Object?> get props => [completer, id];
}