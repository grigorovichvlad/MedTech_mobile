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

class ConnectDevice extends DevicesListEvent{
  ConnectDevice({
    this.completer,
    this.id,
  });
  final Completer? completer;
  final String? id;

  @override
  List<Object?> get props => [completer];
}