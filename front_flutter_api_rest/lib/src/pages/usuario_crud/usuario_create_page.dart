import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_create.dart';
import 'package:front_flutter_api_rest/src/controller/auth/authController.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UsuarioCreatePage extends StatefulWidget {
  @override
  _UsuarioCreatePageState createState() => _UsuarioCreatePageState();
}

class _UsuarioCreatePageState extends State<UsuarioCreatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();


  final _nameController = TextEditingController();
  final _apellido_pController = TextEditingController();
  final _apellido_mController = TextEditingController();
  final _dniController = TextEditingController();
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? selectedRol;
  File? selectedImage;

  UsuarioController usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
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

  void _crearUsuario() async {
    if (_formKey.currentState!.validate()) {
      String? downloadUrl = await _uploadImage(_nombreController.text);

      final nuevoUsuario = UsuarioModel(
        name: _nameController.text,
        apellido_p: _apellido_pController.text,
        apellido_m: _apellido_mController.text,
        dni: _dniController.text,
        codigo: _codigoController.text,
        role: selectedRol ?? "",
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        foto: downloadUrl ?? '',
      );

      try {
        final response =
            await usuarioController.crearUsuario(nuevoUsuario);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario creado con éxito')),
          );
          Navigator.pushNamed(context, AppRoutes.usuarioListRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error al crear Usuario: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error al crear Usuario: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear Usuario: $e')),
        );
      }
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
                Navigator.pushNamed(context, AppRoutes.categoriaListRoute);
              },
            ),
            SizedBox(height: 20), // Espacio entre la AppBar y el formulario
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
                      _buildTextField(_codigoController, 'Codigo', themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_nameController, 'Nombre', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_apellido_pController, 'Apellido Paterno', themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_apellido_mController, 'Apellido Materno', themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_dniController, 'DNI', themeProvider),
                      SizedBox(height: 20),
                      _buildDropdownRol(themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_emailController, 'Email', themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_passwordController, 'Contraseña', themeProvider),
                       SizedBox(height: 20),
                      _buildTextField(_confirmPasswordController, 'Repite la contraseña', themeProvider),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Seleccionar Imagen',
                          style: TextStyle(color: Colors.white),
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
                      // Botón de crear categoría
                      ElevatedButton(
                        onPressed: _crearUsuario,
                        child: Text('Crear Usuario'),
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

  DropdownButtonFormField<String> _buildDropdownRol(
      ThemeProvider themeProvider) {
    final themeColors = themeProvider.getThemeColors();
    return DropdownButtonFormField<String>(
      value: selectedRol,
      onChanged: (String? newValue) {
        setState(() {
          selectedRol = newValue;
        });
      },
      items: ['admin', 'user'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.blue),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Rol',
        filled: true,
        fillColor: themeProvider.isDiurno ? themeColors[1] : themeColors[7],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona un rol';
        }
        return null;
      },
    );
  }
}
