import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/perfilpop.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AppBarEdit extends StatelessWidget {
  final VoidCallback? onBackTap; // Callback para el onTap dinámico

  const AppBarEdit({Key? key, this.onBackTap})
      : super(key: key); // Aceptamos un argumento para el onTap

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      color: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
      padding: EdgeInsets.only(left: 2, right: 2),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap ??
                () {
                  // Usar la función proporcionada o una predeterminada
                  Navigator.pop(
                      context); // Si no se pasa función, simplemente hace pop (volver)
                },
            child: Icon(
              Icons.arrow_back_outlined,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Editar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Spacer(),
          PerfilPop(),
        ],
      ),
    );
  }
}
