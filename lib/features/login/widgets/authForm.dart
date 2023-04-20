import 'package:flutter/material.dart';

import '../bloc/login_page_bloc.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);
  final Function onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _loginBloc = LoginPageBloc();

  // create a TextEditingController
  final _controllerPassword = TextEditingController();
  final _controllerUsername = TextEditingController();

  String? get _errorText {
    final username = _controllerUsername.text;
    final password = _controllerPassword.text;

    // if (endpoinAuth(username, password)) {
    //
    // }

    // return null if the text is valid
    return null;
  }

  // dispose it when the widget is unmounted
  @override
  void dispose() {
    _controllerPassword.dispose();
    _controllerUsername.dispose();
    super.dispose();
  }

  void _submit() {
    // if there is no error text
    if (_errorText == null) {
      // notify the parent widget via the onSubmit callback
      _loginBloc.add(Login(onSubmit: widget.onSubmit));
    }
  }

  @override
  void initState() {
    super.initState();
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
              SizedBox(
                //height: 50,
                child: TextField(
                  clipBehavior: Clip.hardEdge,

                  controller: _controllerUsername,
                  onChanged: (_) => setState(() {}),
                  style: textTheme.bodySmall,
                  decoration: InputDecoration(
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  //height: 50,
                  child: TextField(
                    controller: _controllerPassword,
                    onChanged: (_) => setState(() {}),
                    style: textTheme.bodySmall,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      labelText: 'Пароль',
                      hintText: 'Введите пароль',
                      errorText: _errorText,
                      labelStyle: textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (_controllerPassword.value.text.isNotEmpty && _controllerUsername.value.text.isNotEmpty) {
                 // login
                _submit();
              } else {
                null;
              }
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
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
