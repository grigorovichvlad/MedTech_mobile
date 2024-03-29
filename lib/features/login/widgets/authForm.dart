import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_page_bloc.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.onSubmit, required this.loginBloc})
      : super(key: key);
  final Function onSubmit;
  final LoginPageBloc loginBloc;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _controllerPassword = TextEditingController();
  final _controllerUsername = TextEditingController();
  bool isErrorText = false;
  bool InvalidLogin = false;

  String? get _errorText {
    if (isErrorText) {
      return '- Поля не должны быть пустыми';
    }
    if (InvalidLogin) {
      return '- Неверный логин и пароль';
    }
    return null;
  }


  late LoginPageBloc _loginBloc;
  late StreamSubscription<LoginPageState> _loginStateSubscription;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginPageBloc();
    _loginStateSubscription = _loginBloc.stream.listen((state) {
      if (state is LoginPageFailure) {
        setState(() {
          InvalidLogin = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _loginStateSubscription.cancel();
    _loginBloc.close();
    super.dispose();
  }

  void _submit() {
    final username = _controllerUsername.text;
    final password = _controllerPassword.text;

    setState(() {
      isErrorText = password.isEmpty || username.isEmpty;
    });

    if (_errorText == null) {
      _loginBloc.add(ButtonLoginPressed(
        username: _controllerUsername.text,
        password: _controllerPassword.text,
        onSubmit: widget.onSubmit,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: <Widget>[
        Padding(
          // Контейнер с полями для ввода
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
              30, MediaQuery.of(context).size.width * 0.1, 0),
          child: Column(
            children: <Widget>[
              TextField(
                clipBehavior: Clip.hardEdge,
                controller: _controllerUsername,
                onChanged: (_) => setState(() {
                  isErrorText = false;
                }),
                style: textTheme.bodySmall,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  hintText: 'Введите имя пользователя',
                  labelText: 'Имя пользователя',
                  labelStyle: textTheme.labelSmall,
                  errorText: _errorText,
                  errorStyle: const TextStyle(
                    fontSize: 0,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: TextField(
                  controller: _controllerPassword,
                  onChanged: (_) => setState(() {
                    isErrorText = false;
                  }),
                  style: textTheme.bodySmall,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',
                    errorText: _errorText,
                    errorStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    labelStyle: textTheme.labelSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<LoginPageBloc, LoginPageState>(
            bloc: widget.loginBloc,
            builder: (context, state) {
              if (state is LoginPageSuccess) {
                return Text(
                  'Добро пожаловать, ${_controllerUsername.text}',
                  style: textTheme.bodyMedium,
                );
              }
              if (state is LoginPageInitial) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      debugPrint("Попытка входа");
                      setState(() {
                        _submit();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )),
                    child: Text(
                      'Войти',
                      style: textTheme.headlineLarge,
                    ),
                  ),
                );
              }
              return CircularProgressIndicator(color: theme.indicatorColor);
            }),
        const SizedBox(height: 30),
      ],
    );
  }
}
