// login_header.dart

import 'package:flutter/material.dart';

class LoginRegisterComponent extends StatelessWidget {
  final List<Widget> additionalWidgets; // Lista de widgets adicionales
  final String titleLogin;
  const LoginRegisterComponent(
      {Key? key,
      this.titleLogin = 'No hay titulo del login',
      this.additionalWidgets = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondo_login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 175),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          titleLogin,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Text(
                          'FRANCHESCAS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...additionalWidgets,
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
