import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_edit.dart';
import 'package:front_flutter_api_rest/src/controller/categoriaController.dart';
import 'package:front_flutter_api_rest/src/controller/sub_categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/subCategoriaModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SubCategoriaEditPage extends StatefulWidget {
  final SubCategoriaModel item;

  SubCategoriaEditPage({required this.item});

  @override
  _SubCategoriaEditPageState createState() => _SubCategoriaEditPageState();
}

class _SubCategoriaEditPageState extends State<SubCategoriaEditPage> {
  final _nombreController = TextEditingController();
  final _tagController = TextEditingController();
  String? selectedCategoria;
  String? selectedEstado;
  File? selectedImage; // Para almacenar la imagen seleccionada

  SubCategoriaController subCategoriaController = SubCategoriaController();
  CategoriaController categoriaController = CategoriaController();
  List<Map<String, dynamic>> categorias = [];
  @override
  void initState() {
    _getData();
    super.initState();
    _nombreController.text = widget.item.nombre ?? '';
    _tagController.text = widget.item.tag ?? '';
    selectedEstado = widget.item.estado ?? '';
    selectedCategoria = widget.item.categoria?['id']?.toString();
  }

  Future<void> _getData() async {
    try {
      print("Fetching subcategories");
      final categoriasData = await categoriaController.getDataCategories();
      setState(() {
        categorias = List<Map<String, dynamic>>.from(categoriasData);
      });
    } catch (error) {
      print("Error fetching subcategories: $error");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _editarCategoria() async {
    String newImageUrl = widget.item.foto ?? "";
    int? itemId = widget.item.id;
    String title = widget.item.nombre.toString();

    if (selectedImage != null) {
      String fileName = 'venta/$itemId-$title.png';
      final firebaseStorageReference =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        await firebaseStorageReference.putFile(selectedImage!);
        final downloadUrl = await firebaseStorageReference.getDownloadURL();

        if (downloadUrl != null) {
          newImageUrl = downloadUrl;
        }
      } catch (e) {
        print("Error al cargar la imagen: $e");
      }
    }

    final editarSubCategoria = SubCategoriaModel(
      id: widget.item.id,
      nombre: _nombreController.text,
      tag: _tagController.text,
      estado: selectedEstado ?? "",
      categoria: {'id': selectedCategoria},
      foto: newImageUrl,
    );

    final response =
        await subCategoriaController.editarSubCategoria(editarSubCategoria);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría actualizada con éxito')),
      );
      Navigator.pushNamed(context, AppRoutes.subcategoriaListRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la categoría')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      backgroundColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarEdit(
              onBackTap: () {
                Navigator.pushNamed(context, AppRoutes.subcategoriaListRoute);
              },
            ),
            // Contenedor para mostrar la imagen con un estilo mejorado
            Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.foto.toString(),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/nofoto.jpg'),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                ),
                decoration: BoxDecoration(
                  color:
                      themeProvider.isDiurno ? themeColors[2] : themeColors[0],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4), // Sombra más suave
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Espaciado entre imagen y formulario
            Card(
              color: themeProvider.isDiurno ? themeColors[2] : themeColors[7],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                          _nombreController, 'Nombre', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_tagController, 'Tag', themeProvider),
                      SizedBox(height: 20),
                      _buildDropdownEstado(themeProvider),
                      SizedBox(height: 20),
                      _buildDropdownCategoria(themeProvider),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Seleccionar Imagen',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedImage != null)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _editarCategoria,
                        child: Text('Actualizar Sub Categoria'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label,
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: themeProvider.isDiurno ? themeColors[7] : themeColors[2],
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: themeProvider.isDiurno ? themeColors[10] : themeColors[9],
        ),
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildDropdownEstado(
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return DropdownButtonFormField<String>(
      value: selectedEstado,
      onChanged: (String? newValue) {
        setState(() {
          selectedEstado = newValue;
        });
      },
      items: ['Activo', 'Inactivo'].map((String estado) {
        return DropdownMenuItem<String>(
          value: estado,
          child: Text(
            estado,
            style: TextStyle(color: Colors.blue),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Estado',
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildDropdownCategoria(
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return DropdownButtonFormField<String>(
      value: selectedCategoria,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategoria = newValue;
        });
      },
      items: categorias.map<DropdownMenuItem<String>>((categoria) {
        return DropdownMenuItem<String>(
          value: categoria['id'].toString(),
          child: Text(
            categoria['nombre'],
            style: TextStyle(color: Colors.blue),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Categoría',
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
