part of 'login_page_bloc.dart';

abstract class LoginPageState {}

class LoginPageInitial extends LoginPageState {}

class LoginPageLoading extends LoginPageState {
}

class LoginPageSuccess extends LoginPageState {}


class LoginPageFailure extends LoginPageState { //кидаю ошибку на неверныый вход
  LoginPageFailure({required this.exception});
  final Object? exception;
}