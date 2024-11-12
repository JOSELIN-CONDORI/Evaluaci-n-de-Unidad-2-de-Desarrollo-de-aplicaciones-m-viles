import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:front_flutter_api_rest/src/components/app_bar.dart';
import 'package:front_flutter_api_rest/src/components/delete_item.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/components/error_data.dart';
import 'package:front_flutter_api_rest/src/controller/auth/authController.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthModel.dart';
import 'package:front_flutter_api_rest/src/pages/usuario_crud/usuario_create_page.dart';
import 'package:front_flutter_api_rest/src/pages/usuario_crud/usuario_editar_page.dart';
import 'package:front_flutter_api_rest/src/pages/usuario_crud/usuario_show_page.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UsuariolistPage extends StatefulWidget {
  @override
  _UsuariolistPageState createState() => _UsuariolistPageState();
}

class _UsuariolistPageState extends State<UsuariolistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UsuarioModel> item = [];
  UsuarioController usuarioController = UsuarioController();
  TextEditingController searchController =
      TextEditingController(); // Controlador para el buscador

  @override
  void initState() {
    super.initState();
    _getData(); // Inicialmente, cargamos todos los datos
  }

  Future<void> _getData({String? name}) async {
    try {
      final usuariosData = await usuarioController.getDataUsuario(name: name);
      setState(() {
        item = usuariosData
            .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
            .toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  void _onSearch(String searchQuery) {
    _getData(name: searchQuery);
  }

  Future<void> _removeUsuario(int id, String fotoURL) async {
    final response = await usuarioController.removeUsuario(id, fotoURL);

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario eliminada con éxito')),
      );
      _getData();
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al eliminar Usuario: tiene elementos relacionados.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar Usuario.')),
      );
    }
  }

  void _showDeleteDialog(int id, String fotoURL) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          id: id,
          fotoURL: fotoURL,
          onConfirmDelete: _removeUsuario,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      backgroundColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
      key: _scaffoldKey,
      appBar: AppBarComponent(
        appBarColor: themeProvider.isDiurno ? themeColors[2] : themeColors[0],
      ),
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 68,
              color: themeProvider.isDiurno ? themeColors[2] : themeColors[0],
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: TextField(
                  cursorColor: Colors.white,
                  controller: searchController,
                  onChanged: (value) {
                    _onSearch(value);
                  },
                  style: TextStyle(
                    color: themeProvider.isDiurno
                        ? themeColors[7]
                        : themeColors[2],
                  ),
                  decoration: InputDecoration(
                    labelText: 'Buscar categoría',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        _onSearch(searchController.text);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: themeProvider.isDiurno ? themeColors[2] : themeColors[0],
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1), // Sombra más suave
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(-2, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 160,
                    child: Text(
                      '¡Bienvenido a la gestión de usuario!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsuarioCreatePage(),
                        ),
                      );
                    },
                    child: ClipPath(
                      clipper: SideCutClipper(),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.blue,
                                opticalSize: 18,
                              ),
                              Text(
                                'Crear',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            item.isEmpty
                ? ErrorData()
                : Column(
                    children: item.map<Widget>((usuario) {
                      return Dismissible(
                        key: Key(usuario.id.toString()), // Clave única
                        direction: DismissDirection
                            .endToStart, // Deslizar de derecha a izquierda
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          // Confirmar antes de eliminar
                          bool? shouldDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmar eliminación"),
                                content: Text(
                                    "¿Estás seguro de eliminar este usuario?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text("Eliminar"),
                                  ),
                                ],
                              );
                            },
                          );
                          return shouldDelete ?? false;
                        },
                        onDismissed: (direction) {
                          _removeUsuario(usuario.id!, usuario.foto!);
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: themeProvider.isDiurno
                                    ? themeColors[2]
                                    : themeColors[0],
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(0.1), // Sombra más suave
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(-2, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Nombre :',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                usuario.name ?? 'No hay nombre',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Codigo :',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                usuario.codigo ??
                                                    'No hay codigo',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Fecha de Creación:',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      8), // Espaciado entre el texto y la fecha
                                              Text(
                                                usuario.created_at != null
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            usuario
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
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UsuarioEditPage(
                                                        item: usuario),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            child: Icon(Icons.edit,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UsuarioShowPage(
                                                        item: usuario),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            child: Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
