import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_create.dart';
import 'package:front_flutter_api_rest/src/controller/productoController.dart';
import 'package:front_flutter_api_rest/src/controller/sub_categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/productoModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductoCreatePage extends StatefulWidget {
  @override
  _ProductoCreatePageState createState() => _ProductoCreatePageState();
}

class _ProductoCreatePageState extends State<ProductoCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario

  final _nombreController = TextEditingController();
  final _descripController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  String? selectedSubCategoria;
  String? selectedEstado;
  File? selectedImage;

  ProductoController productoController = ProductoController();
  SubCategoriaController subCategoriaController = SubCategoriaController();
  List<Map<String, dynamic>> subCategorias = [];

  @override
  void initState() {
    super.initState();
    _getData();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  Future<void> _getData() async {
    try {
      print("Fetching subcategories");
      final subCategoriesData =
          await subCategoriaController.getDataSubCategoria();
      setState(() {
        subCategorias = List<Map<String, dynamic>>.from(subCategoriesData);
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

  Future<String?> _uploadImage(String title) async {
    try {
      if (selectedImage != null) {
        final fileName = 'venta/$title-${DateTime.now()}.png';
        final firebaseStorageReference =
            FirebaseStorage.instance.ref().child(fileName);

        await firebaseStorageReference.putFile(selectedImage!);
        final downloadUrl = await firebaseStorageReference.getDownloadURL();

        return downloadUrl;
      } else {
        return null;
      }
    } catch (error) {
      print("Error uploading image: $error");
      return null;
    }
  }

  void _crearProducto() async {
    if (_formKey.currentState!.validate()) {
      String? downloadUrl = await _uploadImage(_nombreController.text);

      final nuevoProducto = ProductoModel(
        nombre: _nombreController.text,
        descrip: _descripController.text,
        precio: _precioController.text,
        stock: _stockController.text,
        subCategoria: {'id': selectedSubCategoria},
        estado: selectedEstado ?? "",
        foto: downloadUrl ?? '',
      );

      try {
        final response = await productoController.crearProducto(nuevoProducto);
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto creado con éxito')),
          );
          Navigator.pushNamed(context, AppRoutes.productoListRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al crear el producto: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error al crear el producto: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el producto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarCreate(
              onBackTap: () {
                Navigator.pushNamed(context, AppRoutes.productoListRoute);
              },
            ),
            SizedBox(height: 20),
            Card(
              color: themeProvider.isDiurno ? themeColors[2] : themeColors[7],
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                          _nombreController, 'Nombre', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _descripController, 'Descripción', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _precioController, 'Precio', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_stockController, 'Stock', themeProvider),
                      SizedBox(height: 20),
                      _buildDropdownEstado(themeProvider),
                      SizedBox(height: 20),
                      _buildDropdownSubCategoria(themeProvider),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.image, color: Colors.white),
                        label: Text('Seleccionar Imagen',
                            style: TextStyle(color: Colors.white)),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeProvider.isDiurno
                                  ? themeColors[2]
                                  : themeColors[0],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white
                                      .withOpacity(0.4), // Sombra más suave
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _crearProducto,
                        child: Text('Crear Producto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa $label';
        }
        return null;
      },
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
      items: ['Activo', 'Inactivo'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona un estado';
        }
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildDropdownSubCategoria(
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return DropdownButtonFormField<String>(
      value: selectedSubCategoria,
      onChanged: (String? newValue) {
        setState(() {
          selectedSubCategoria = newValue;
        });
      },
      items: subCategorias.map<DropdownMenuItem<String>>((subCategoria) {
        return DropdownMenuItem<String>(
          value: subCategoria['id'].toString(),
          child: Text(
            subCategoria['nombre'],
            style: TextStyle(color: Colors.blue),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Sub Categoría',
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona una subcategoria';
        }
        return null;
      },
    );
  }
}
