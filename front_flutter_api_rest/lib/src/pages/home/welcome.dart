// ignore: file_names
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
   
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: HexColor('#2b96ed'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centra horizontalmente
          children: [
            Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'WELCOME',
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight
                              .w500, // Peso medio para un efecto moderno
                          color: Colors.white, // Azul más brillante
                          letterSpacing:
                              12.0, // Espaciado entre letras (ajusta a tu gusto)
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'FRANCHESCAS',
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontSize: 55,
                          color: Colors.white, // Azul más brillante
                          letterSpacing:
                              -2.0, // Espaciado entre letras (ajusta a tu gusto)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Espacio entre texto y la animación
                  // Efecto de tipeo
                  Center(
                    child: DefaultTextStyle(
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          fontSize: 40,
                          color: Colors.white, // Azul más brillante
                          letterSpacing:
                              2.0, // Espaciado entre letras (ajusta a tu gusto)
                        ),
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            'Pontelo tu',
                            speed: Duration(
                                milliseconds:
                                    200), 
                          ),
                        ],
                        repeatForever: false,
                        totalRepeatCount: 1, 
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
