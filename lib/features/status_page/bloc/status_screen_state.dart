part of 'status_screen_bloc.dart';

abstract class StatusState extends Equatable{}

class StatusScreenInitial extends StatusState {
  @override
  List<Object?> get props => [];
}

class StatusScreenLoading extends StatusState {

  @override
  List<Object?> get props => [];
}

class StatusScreenLoaded extends StatusState {
  StatusScreenLoaded(this.count, this.dataSize, this.internetConnection);
  final int count, dataSize;
  final bool internetConnection;

  @override
  List<Object?> get props => [count, dataSize, internetConnection];
}

class StatusScreenLoadingFailure extends StatusState {
  StatusScreenLoadingFailure();

  @override
  List<Object?> get props => [];
}