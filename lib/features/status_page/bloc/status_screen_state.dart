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
  StatusScreenLoaded(this.data);
  final String data;

  @override
  List<Object?> get props => [data];
}

class StatusScreenLoadingFailure extends StatusState {
  StatusScreenLoadingFailure();

  @override
  List<Object?> get props => [];
}