import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_edit.dart';
import 'package:front_flutter_api_rest/src/controller/auth/authController.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UsuarioEditPage extends StatefulWidget {
  final UsuarioModel item;

  UsuarioEditPage({required this.item});

  @override
  _UsuarioEditPageState createState() => _UsuarioEditPageState();
}

class _UsuarioEditPageState extends State<UsuarioEditPage> {
  final _nameController = TextEditingController();
  final _apellido_pController = TextEditingController();
  final _apellido_mController = TextEditingController();
  final _dniController = TextEditingController();
  final _codigoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? selectedRol;
  File? selectedImage; // Para almacenar la imagen seleccionada
  UsuarioController usuarioController = UsuarioController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.item.name ?? 'no hay nombre';
    _apellido_pController.text = widget.item.apellido_p ?? 'no hay apellido p';
    _apellido_mController.text = widget.item.apellido_m ?? 'no hay apellido m';
    _dniController.text = widget.item.dni ?? 'no hay dni';
    _codigoController.text = widget.item.codigo ?? 'no hay codigo';
    selectedRol = widget.item.role ?? 'no hay rol';
    _emailController.text = widget.item.email ?? 'no hay email';
    _passwordController.text = widget.item.password ?? 'no hay contraseña';
    // _confirmPasswordController.text =
    //     widget.item.confirmPassword ?? 'no hay contraseña dos';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path); // Asigna la imagen seleccionada
      });
    }
  }

  void _editarUsuario() async {
    String newImageUrl = widget.item.foto ?? "";
    int? itemId = widget.item.id;
    String title = widget.item.name.toString();

    // Subir la nueva imagen si se ha seleccionado una
    if (selectedImage != null) {
      String fileName = 'venta/$itemId-$title.png';
      final firebaseStorageReference =
          FirebaseStorage.instance.ref().child(fileName);

      try {
        await firebaseStorageReference.putFile(selectedImage!);
        final downloadUrl = await firebaseStorageReference.getDownloadURL();

        if (downloadUrl != null) {
          newImageUrl = downloadUrl; // Actualizar URL de la imagen
        }
      } catch (e) {
        print("Error al cargar la imagen: $e");
      }
    }

    final editarUsuario = UsuarioModel(
      id: widget.item.id, // Usa el id del ítem existente
      name: _nameController.text,
      apellido_p: _apellido_pController.text,
      apellido_m: _apellido_mController.text,
      dni: _dniController.text,
      codigo: _codigoController.text,
      role: selectedRol ?? "",
      email: _emailController.text,
      password: _passwordController.text,
      // confirmPassword: _confirmPasswordController.text,
      foto: newImageUrl,
    );

    final response = await usuarioController.editarUsuario(editarUsuario);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario actualizado con éxito')),
      );
      Navigator.pushNamed(context, AppRoutes.usuarioListRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar Usuario')),
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
                Navigator.pushNamed(context, AppRoutes.usuarioListRoute);
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
                          _codigoController, 'Codigo', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_nameController, 'Nombre', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_apellido_pController, 'Apellido Paterno',
                          themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(_apellido_mController, 'Apellido Materno',
                          themeProvider),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildTextField(
                                  _dniController, 'DNI', themeProvider),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: _buildDropdownRol(themeProvider),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_emailController, 'Email', themeProvider),
                      SizedBox(height: 20),
                      _buildTextField(
                          _passwordController, 'Contraseña', themeProvider),
                      //  SizedBox(height: 20),
                      // _buildTextField(_confirmPasswordController, 'Repite la contraseña', themeProvider),
                      SizedBox(height: 20),
                      // Botón para seleccionar una imagen
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
                        onPressed: _editarUsuario,
                        child: Text('Actualizar Usuario'),
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
      items: ['admin', 'user'].map((String role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(
            role,
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
    );
  }
}
