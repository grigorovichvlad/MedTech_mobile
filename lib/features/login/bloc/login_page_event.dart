part of 'login_page_bloc.dart';

abstract class LoginPageEvent {}

class  ButtonLoginPressed extends LoginPageEvent{
  ButtonLoginPressed({required this.username, required this.password, required this.onSubmit, this.completer});
  final Function onSubmit;
  final String? username;
  final String? password;
  loginUser(username, password) {
    debugPrint("Вход успешен");
    throw UnimplementedError();
  }
  final Completer? completer;
}

Future<bool> loginUser(String username, String password) async {
  final response = await Dio().post(
    'https://endpoint.com/login',
    data: {'username': username, 'password': password},
  );

  if ((username == 'admin') && (password == 'admin')) {
    return true;
  }
  else {
    return response.statusCode == 200;
  }// 200 вход успешен
}

class LoginOnLaunch extends LoginPageEvent{
  LoginOnLaunch({required this.onSubmit, this.completer});
  final Function onSubmit;

  final Completer? completer;
}

