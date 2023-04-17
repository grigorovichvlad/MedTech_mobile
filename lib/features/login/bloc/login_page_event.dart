part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class Login extends LoginPageEvent{
  Login({required this.onSubmit, this.completer});
  final Function onSubmit;

  final Completer? completer;
}