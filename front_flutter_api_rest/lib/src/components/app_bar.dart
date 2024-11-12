import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_flutter_api_rest/src/components/perfilpop.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  final Color appBarColor;

  AppBarComponent({required this.appBarColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarColor,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ), // Icono del drawer
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Abrir el drawer
        },
      ),
      actions: [
        PerfilPop(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
