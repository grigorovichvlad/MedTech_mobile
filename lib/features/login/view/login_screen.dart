import 'package:flutter/material.dart';
import 'package:med_tech_mobile/features/login/bloc/login_page_bloc.dart';
import 'dart:ui';
import 'package:med_tech_mobile/features/login/widgets/authForm.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  List<String> loginViaImages = [
    'assets/images/apple.webp',
    'assets/images/google.png',
    'assets/images/at.png',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              // Фон с облаками + иконка приложения
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: Transform.scale(
                        alignment: Alignment.bottomCenter,
                        scale: window.physicalSize.width / 711,
                        child: Image.asset('assets/images/backround_login.png'),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 150,
                  left:
                      window.physicalSize.width / window.devicePixelRatio / 2 -
                          50,
                  child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(50, 0, 0, 0),
                              offset: Offset(0, 5),
                              blurRadius: 5)
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/icon.png'),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Text(
                'Вход',
                style: textTheme.bodyLarge,
              ),
            ),
            Row(
              // "Войти через" кнопки
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                loginViaButton(loginViaImages[0]),
                SizedBox(width: 30),
                loginViaButton(loginViaImages[1]),
                SizedBox(width: 30),
                loginViaButton(loginViaImages[2]),
              ],
            ),
            AuthForm(
              onSubmit: () {
                Navigator.pushReplacementNamed(context, '/devices');
              },
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.6),
          ],
        ),
      ),
    );
  }

  Widget loginViaButton(String path) {
    return SizedBox(
      height: 50,
      width: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ).copyWith(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return const BorderSide(
                    color: Colors.blue); // цвет границы при нажатии
              }
              return const BorderSide(color: Colors.grey);
            },
          ),
        ),
        child: Image.asset(path),
      ),
    );
  }
}
