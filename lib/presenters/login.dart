import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  List<String> loginViaImages = [
    'assets/images/apple.webp',
    'assets/images/google.png',
    'assets/images/at.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Container(
                          )),
                        Positioned(
                          top: 0,
                          child:
                          Transform.translate(
                            offset: Offset(-15, -125),
                            child: Image.asset(
                              'assets/images/backround_login.png',
                              scale: 3,
                            ),
                          ),
                        ),
                      ],
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(145, 0, 145, 0),
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const [
                            BoxShadow(color: Color.fromARGB(50, 0, 0, 0), offset: Offset(0, 5), blurRadius: 5)
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/icon.png'),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Text(
                'Вход',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                loginViaButton(loginViaImages[0]),
                SizedBox(width: 30),
                loginViaButton(loginViaImages[1]),
                SizedBox(width: 30),
                loginViaButton(loginViaImages[2]),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50,
                    child: const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Введите имя пользователя',
                        labelText: 'Имя пользователя',
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      autofocus: false,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          labelText: 'Пароль',
                          hintText: 'Введите пароль',
                          labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        autofocus: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )),
                child: const Text(
                  'Войти',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(
                color: Colors.grey,
              ),
            )),
        child: Image.asset(path),
      ),
    );
  }
}
