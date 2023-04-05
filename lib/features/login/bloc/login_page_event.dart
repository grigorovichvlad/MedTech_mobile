part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class Login extends LoginPageEvent{

  Login({this.completer});
  final Completer? completer;

}