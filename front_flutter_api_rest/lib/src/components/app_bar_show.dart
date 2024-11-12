import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/perfilpop.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class AppBarShow extends StatelessWidget {
  final VoidCallback? onBackTap;
  final String title;

  const AppBarShow({Key? key, this.onBackTap, this.title = 'No hay titulo'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Container(
      color: themeProvider.isDiurno ? themeColors[2] : themeColors[0],
      padding: EdgeInsets.only(left: 2, right: 2),
      child: Row(
        children: [
          InkWell(
            onTap: onBackTap ??
                () {
                  Navigator.pop(context);
                },
            child: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
