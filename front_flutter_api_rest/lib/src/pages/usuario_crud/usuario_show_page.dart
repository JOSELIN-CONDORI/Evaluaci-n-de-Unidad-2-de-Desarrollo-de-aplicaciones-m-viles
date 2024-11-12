import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_show.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsuarioShowPage extends StatefulWidget {
  final UsuarioModel item;

  UsuarioShowPage({required this.item});

  @override
  _UsuarioShowPageState createState() => _UsuarioShowPageState();
}

class _UsuarioShowPageState extends State<UsuarioShowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      backgroundColor: themeProvider.isDiurno ? themeColors[2] : themeColors[0],
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppBarShow(
              onBackTap: () {
                Navigator.pushNamed(context, AppRoutes.usuarioListRoute);
              },
              title: widget.item.name?.toString() ?? 'no hay name',
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.item.foto.toString(),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/nofoto.jpg'),
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: themeProvider.isDiurno
                          ? themeColors[2]
                          : themeColors[0],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.white.withOpacity(0.4), // Sombra más suave
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 160,
                    child: Center(
                        child: Text(
                      widget.item.name?.toString().toUpperCase() ??
                          'no hay name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
            Container(
              child: ClipPath(
                clipper: WaveClipperOne(reverse: true),
                child: Container(
                  height: 520,
                  width: MediaQuery.of(context)
                      .size
                      .width, // Establecer la altura según la pantalla
                  decoration: BoxDecoration(
                    color: themeProvider.isDiurno
                        ? themeColors[1]
                        : themeColors[7],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 90),
                        ClipPath(
                          clipper: WaveClipperOne(reverse: true),
                          child: Container(
                            width: 380,
                            padding: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Rol del usuario:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.role.toString() ??
                                          'no hay role',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Nombre del usuario:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.name.toString() ??
                                          'no hay codigo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Codigo del usuario:',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.item.codigo.toString() ??
                                          'no hay codigo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: themeProvider.isDiurno
                                  ? themeColors[2]
                                  : themeColors[0],
                              borderRadius: BorderRadius.circular(150),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white
                                      .withOpacity(0.1), // Sombra más suave
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(-2, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipPath(
                              clipper: SideCutClipper(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de Creación',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Espaciado entre el texto y la fecha
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.created_at != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(widget
                                                          .item
                                                          .created_at!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .access_time, // Icono de la hora
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.created_at != null
                                                  ? DateFormat('HH:mm').format(
                                                      DateTime.parse(widget.item
                                                          .created_at!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: themeProvider.isDiurno
                                      ? themeColors[2]
                                      : themeColors[0],
                                  borderRadius: BorderRadius.circular(150),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.1), // Sombra más suave
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(-2, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ClipPath(
                              clipper: SideCutClipper(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fecha de Actualización',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Espaciado entre el texto y la fecha
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.updated_at != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(widget
                                                          .item
                                                          .updated_at!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .access_time, // Icono de la hora
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              widget.item.updated_at != null
                                                  ? DateFormat('HH:mm').format(
                                                      DateTime.parse(widget.item
                                                          .updated_at!)) // Convertir el String a DateTime
                                                  : 'Fecha no disponible', // Valor predeterminado si es nulo
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: themeProvider.isDiurno
                                      ? themeColors[2]
                                      : themeColors[0],
                                  borderRadius: BorderRadius.circular(150),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white
                                          .withOpacity(0.1), // Sombra más suave
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(-2, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
