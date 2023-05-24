part of 'status_screen_bloc.dart';

abstract class StatusEvent extends Equatable{
  get completer => null;
}

class LoadStatusScreen extends StatusEvent{
  LoadStatusScreen({required this.onDisconnect});
  final void Function() onDisconnect;

  @override
  List<Object?> get props => [onDisconnect];
}

class LoadStatus extends StatusEvent{
  LoadStatus();

  @override
  List<Object?> get props => [];
}

