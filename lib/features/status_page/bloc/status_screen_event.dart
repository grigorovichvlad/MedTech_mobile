part of 'status_screen_bloc.dart';

abstract class StatusScreenEvent extends Equatable{
  get completer => null;
}

class LoadStatusScreen extends StatusScreenEvent{
  LoadStatusScreen();

  @override
  List<Object?> get props => [];
}