part of 'login_page_bloc.dart';

abstract class LoginPageState {}

class LoginPageInitial extends LoginPageState {}

class LoginPageLoading extends LoginPageState {}

class LoginPageLoginRight extends LoginPageState { // если логин валид


}

class LoginPageLoginFailure extends LoginPageState { //кидаю ошибку на неверныый вход
  LoginPageLoginFailure({required this.exception});
  final Object? exception;
}