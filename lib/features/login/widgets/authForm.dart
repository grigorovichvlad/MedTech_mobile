import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';

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
  final _controllerPassword =
      TextEditingController(); //дают возможность получить текст из текстового поля
  final _controllerUsername = TextEditingController();

  String? get _errorText {
    final username = _controllerUsername.text;
    final password = _controllerPassword.text;

    //TODO: CleanFormat
    // if (!CleanFormat) {
    //  return 'bad format';
    // }
    return null;
  }

  void _submit() {
    if (_errorText == null) {
      // if there is no error text
      widget.loginBloc.add(ButtonLoginPressed(
          username: _controllerUsername.text,
          password: _controllerPassword.text,
          onSubmit: widget.onSubmit));
    }
  }

  @override
  void dispose() {
    _controllerPassword.dispose();
    _controllerUsername.dispose();
    super.dispose();
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
                      border: const OutlineInputBorder(),
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
        BlocBuilder<LoginPageBloc, LoginPageState>(
            bloc: widget.loginBloc,
            builder: (context, state) {
              if (state is LoginPageLoginRight) {
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
                      if (_controllerPassword.value.text.isNotEmpty &&
                          _controllerUsername.value.text.isNotEmpty) {
                        // loginx
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
                );
              }
              return CircularProgressIndicator(color: theme.indicatorColor);
            }),
        const SizedBox(height: 30),
      ],
    );

    //   return Center(
    //       child: CircularProgressIndicator(color: theme.indicatorColor));
    // });
  }
}
