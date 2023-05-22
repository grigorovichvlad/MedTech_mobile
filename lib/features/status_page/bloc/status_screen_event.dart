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
class LoadStatus extends StatusEvent{
  LoadStatus();

  @override
  List<Object?> get props => [];
}


class LoadDataInLocalDB extends StatusEvent{
  LoadDataInLocalDB({required this.data});
  final String data;

  @override
  List<Object?> get props => [];
}