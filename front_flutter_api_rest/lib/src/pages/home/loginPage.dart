// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/login_register_component.dart';
import 'package:front_flutter_api_rest/src/controller/auth/login_register.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthRequestModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:snippet_coder_utils/FormHelper.dart'; // Asegúrate de tener este helper

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool hidenPassword = true;
  bool isAPIcallProcess = false; // Para manejar el estado de la API

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LoginRegisterComponent(
        titleLogin: 'Login',
        additionalWidgets: [
          SizedBox(height: 80),
          Form(
            key: globalFormkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: HexColor("#2C98F0")),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: HexColor("#2C98F0")),
                    ),
                    helperStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (onValidateVal) {
                    if (onValidateVal!.isEmpty) {
                      return "Email can't be empty.";
                    }
                    return null;
                  },
                  onSaved: (onSavedVal) {
                    email = onSavedVal!; // Guarda el valor del email
                  },
                ),
                SizedBox(height: 20), // Espaciado entre campos
                TextFormField(
                  obscureText: hidenPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: HexColor("#2C98F0")),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: HexColor("#2C98F0")),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            hidenPassword = !hidenPassword;
                          });
                        }
                      },
                      color: Colors.grey,
                      icon: Icon(
                        hidenPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (onValidateVal) {
                    if (onValidateVal!.isEmpty) {
                      return "Password can't be empty.";
                    }
                    if (onValidateVal.length < 2) {
                      return "Password must be at least 8 characters.";
                    }
                    return null;
                  },
                  onSaved: (onSavedVal) {
                    password = onSavedVal!; // Guarda el valor de la contraseña
                  },
                ),
                SizedBox(height: 35), // Espaciado entre campos
                FormHelper.submitButton(
                  "Login",
                  () {
                    if (validateAndSave()) {
                      setState(() {
                        isAPIcallProcess = true;
                      });

                      AuthRequestModel model =
                          AuthRequestModel(email: email, password: password);

                      LoginRegisterController.login(model).then((response) {
                        setState(() {
                          isAPIcallProcess = false;
                        });
                        if (response) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home', 
                            (route) => false,
                          );
                        } else {
                          FormHelper.showSimpleAlertDialog(
                            context,
                            "Error",
                            "User or password is incorrect!",
                            "OK",
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      });
                    }
                  },
                  btnColor: HexColor("#2C98F0"),
                  borderColor: Colors.white,
                  txtColor: Colors.white,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Establecer la altura según la pantalla
                  borderRadius: 50,
                ),
                SizedBox(height: 30), // Espaciado entre campos
                Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'Olvidó su contraseña?',
                    style: TextStyle(
                      color: HexColor("#2C98F0"),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 120), // Espaciado entre campos
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.registerRoute);
                        },
                        child: Text(
                          'Registrate',
                          style: TextStyle(
                            color: HexColor("#2C98F0"),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
