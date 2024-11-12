import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/login_register_component.dart';
import 'package:front_flutter_api_rest/src/controller/auth/login_register.dart';
import 'package:front_flutter_api_rest/src/model/auth/RegisterRequestModel.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:front_flutter_api_rest/src/services/api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> globalFormkey = GlobalKey<FormState>();
  bool isAPIcallProcess = false;
  bool hidenPassword = true;

  String? email;
  String? password;
  String? confirmPassword;
  @override
  void initState() {
    super.initState();

    // Esconder el sistema de interfaz de usuario (status bar, etc.)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: LoginRegisterComponent(
        titleLogin: 'Register',
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
                SizedBox(height: 20), // Espaciado entre campos
                TextFormField(
                  obscureText: hidenPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                  ),
                  validator: (onValidateVal) {
                    if (onValidateVal!.isEmpty) {
                      return "confirmPassword can't be empty.";
                    }
                    if (onValidateVal.length < 2) {
                      return "confirmPassword must be at least 8 characters.";
                    }
                    return null;
                  },
                  onSaved: (onSavedVal) {
                    confirmPassword = onSavedVal!;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          FormHelper.submitButton(
            "Register",
            () {
              if (validateAndSave()) {
                setState(() {
                  isAPIcallProcess = true;
                });

                RegisterRequestModel model = RegisterRequestModel(
                  email: email,
                  password: password,
                  confirmPassword: confirmPassword,
                );

                LoginRegisterController.register(model).then((response) {
                  setState(() {
                    isAPIcallProcess = false;
                  });
                  if (response.user != null) {
                    FormHelper.showSimpleAlertDialog(
                      context,
                      ConfigApi.appName,
                      "Te registraste correctamente. Ahora puedes logearte",
                      "OK",
                      () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                    );
                  } else {
                    showErrorDialog(context, response.message);
                  }
                }).catchError((error) {
                  showErrorDialog(context, error.toString());
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
          SizedBox(height: 20),
          Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              'OR',
              style: TextStyle(
                color: HexColor("#2C98F0"),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: AlignmentDirectional.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: HexColor("#2C98F0"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/google.jpg'),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: HexColor("#2C98F0"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/facebook.jpg'),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: HexColor("#2C98F0"),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/outlook.jpg'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Espaciado entre campos
          Container(
            alignment: Alignment
                .bottomCenter, // Centra el contenido dentro del Container
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centra los elementos en la fila
              children: [
                Text(
                  "Do you already have an account?",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8), // Espacio entre los dos textos
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context,
                        AppRoutes.loginRoute); // Usar la constante de la ruta
                  },
                  child: Text(
                    'Login',
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

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Redirigir al usuario de nuevo a la página de registro
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
