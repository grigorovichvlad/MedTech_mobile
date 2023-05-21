part of 'status_screen_bloc.dart';

abstract class StatusEvent extends Equatable{
  get completer => null;
}

class LoadStatusScreen extends StatusEvent{
  LoadStatusScreen();

  @override
  List<Object?> get props => [];
}

class LoadDataInDB extends StatusEvent{
  LoadDataInDB();

  @override
  List<Object?> get props => [];
}