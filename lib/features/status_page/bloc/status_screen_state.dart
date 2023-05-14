part of 'status_screen_bloc.dart';

abstract class StatusScreenState extends Equatable{}

class StatusScreenInitial extends StatusScreenState {
  @override
  List<Object?> get props => [];
}

class StatusScreenLoading extends StatusScreenState {
  @override
  List<Object?> get props => [];
}

class StatusScreenLoaded extends StatusScreenState {
  StatusScreenLoaded();

  @override
  List<Object?> get props => [];
}

class StatusScreenLoadingFailure extends StatusScreenState {
  StatusScreenLoadingFailure();

  @override
  List<Object?> get props => [];
}