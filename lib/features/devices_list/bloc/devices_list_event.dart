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


  @override
  List<Object?> get props => throw UnimplementedError();
}
