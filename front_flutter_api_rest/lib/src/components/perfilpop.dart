import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';

class PerfilPop extends StatefulWidget {
  @override
  _PerfilPopState createState() => _PerfilPopState();
}

class _PerfilPopState extends State<PerfilPop> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String accountFoto = "";
  String accountName = "";

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final loginDetails = await ShareApiTokenController.loginDetails();

    if (loginDetails != null) {
      setState(() {
        accountFoto = loginDetails.user?.foto ?? "";
        accountName =
            truncateText(loginDetails.user?.name ?? "no hay nombre", 10);
      });
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  void _showProfileMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 60, 10, 10),
      items: [
        PopupMenuItem<int>(
          enabled: false,
          height: 0, // Elimina el padding vertical del PopupMenuItem
          child: Center(
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minWidth: 0, // Controla el ancho mínimo del contenedor
                minHeight: 0, // Controla el alto mínimo del contenedor
              ),
              child: Text(
                accountName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: Text("Perfil"),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Text("Configuración"),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text("Cerrar sesión"),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _onMenuOptionSelected(context, value);
      }
    });
  }

  void _onMenuOptionSelected(BuildContext context, int value) {
    switch (value) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil seleccionado')),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuración seleccionada')),
        );
        break;
      case 2:
        ShareApiTokenController.logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: GestureDetector(
        onTap: () {
          _showProfileMenu(context);
        },
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(accountFoto),
          ),
        ),
      ),
    );
  }
}
