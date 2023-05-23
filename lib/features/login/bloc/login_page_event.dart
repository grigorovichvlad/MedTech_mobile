part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class  ButtonLoginPressed extends LoginPageEvent{
  ButtonLoginPressed({required this.username, required this.password, required this.onSubmit, this.completer});
  final Function onSubmit;
  final String? username;
  final String? password;
  final Completer? completer;
}

class LoginOnLaunch extends LoginPageEvent{
  LoginOnLaunch({required this.onSubmit, this.completer});
  final Function onSubmit;

  final Completer? completer;
}

