import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:front_flutter_api_rest/src/components/app_bar.dart';
import 'package:front_flutter_api_rest/src/components/delete_item.dart';
import 'package:front_flutter_api_rest/src/components/drawers.dart';
import 'package:front_flutter_api_rest/src/components/error_data.dart';
import 'package:front_flutter_api_rest/src/model/categoriaModel.dart';
import 'package:front_flutter_api_rest/src/controller/categoriaController.dart';
import 'package:front_flutter_api_rest/src/pages/categoria_crud/category_create_page.dart';
import 'package:front_flutter_api_rest/src/pages/categoria_crud/category_edit_page.dart';
import 'package:front_flutter_api_rest/src/pages/categoria_crud/category_show_page.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CategorialistPage extends StatefulWidget {
  @override
  _CategorialistPageState createState() => _CategorialistPageState();
}

class _CategorialistPageState extends State<CategorialistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CategoriaModel> item = [];
  CategoriaController categoriaController = CategoriaController();
  TextEditingController searchController =
      TextEditingController(); // Controlador para el buscador

  @override
  void initState() {
    super.initState();
    _getData(); // Inicialmente, cargamos todos los datos
  }

  Future<void> _getData({String? nombre}) async {
    try {
      final categoriesData =
          await categoriaController.getDataCategories(nombre: nombre);
      setState(() {
        item = categoriesData
            .map<CategoriaModel>((json) => CategoriaModel.fromJson(json))
            .toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  void _onSearch(String searchQuery) {
    _getData(nombre: searchQuery);
  }

  Future<void> _removeCategoria(int id, String fotoURL) async {
    final response = await categoriaController.removeCategoria(id, fotoURL);

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría eliminada con éxito')),
      );
      _getData();
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error al eliminar la categoría: tiene elementos relacionados.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la categoría.')),
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
          onConfirmDelete: _removeCategoria,
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
                      '¡Bienvenido a la gestión de categorías!',
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
                          builder: (context) => CategoriaCreatePage(),
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
                    children: item.map<Widget>((categoria) {
                      return Dismissible(
                        key: Key(categoria.id.toString()), // Clave única
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
                                    "¿Estás seguro de eliminar esta categoría?"),
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
                          _removeCategoria(categoria.id!, categoria.foto!);
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
                                                categoria.nombre ??
                                                    'No hay nombre',
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
                                                'Tag :',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                categoria.tag ?? 'No hay Tag',
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
                                                categoria.createdAt != null
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                            categoria
                                                                .createdAt!)) // Convertir el String a DateTime
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
                                                    CategoriaEditPage(
                                                        item: categoria),
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
                                                    CategoriaShowPage(
                                                        item: categoria),
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
