import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/components/app_bar_edit.dart';
import 'package:front_flutter_api_rest/src/controller/productoController.dart';
import 'package:front_flutter_api_rest/src/controller/sub_categoriaController.dart';
import 'package:front_flutter_api_rest/src/model/productoModel.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductoEditPage extends StatefulWidget {
  final ProductoModel item;

  ProductoEditPage({required this.item});

  @override
  _ProductoEditPageState createState() => _ProductoEditPageState();
}

class _ProductoEditPageState extends State<ProductoEditPage> {
  final _nombreController = TextEditingController();
  final _descripController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  String? selectedSubCategoria;
  String? selectedEstado;
  File? selectedImage; // Para almacenar la imagen seleccionada
  ProductoController productoController = ProductoController();
  SubCategoriaController subCategoriaController = SubCategoriaController();
  List<Map<String, dynamic>> subCategorias = [];
  @override
  void initState() {
    super.initState();
    _getData();
    // Cargar los datos del producto en los controladores
    _nombreController.text = widget.item.nombre ?? '';
    _descripController.text = widget.item.descrip ?? '';
    _precioController.text = widget.item.precio ?? '';
    _stockController.text = widget.item.stock ?? '';
    selectedEstado = widget.item.estado ?? '';
    selectedSubCategoria = widget.item.subCategoria?['id']
        ?.toString();
  }

  Future<void> _getData() async {
    try {
      print("Fetching subcategories");
      final subCategoriesData = await subCategoriaController.getDataSubCategoria();
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
        selectedImage = File(pickedFile.path); // Asigna la imagen seleccionada
      });
    }
  }

  void _editarProducto() async {
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
          newImageUrl = downloadUrl; // Actualizar URL de la imagen
        }
      } catch (e) {
        print("Error al cargar la imagen: $e");
      }
    }

    final productoEditado = ProductoModel(
      id: widget.item.id,
      nombre: _nombreController.text,
      descrip: _descripController.text,
      precio: _precioController.text,
      stock: _stockController.text,
      estado: selectedEstado ?? "",
      subCategoria: {'id': selectedSubCategoria},
      foto: newImageUrl,
    );

    final response = await productoController.editarProducto(productoEditado);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto actualizado con éxito')),
      );
      Navigator.pushNamed(context, AppRoutes.productoListRoute);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar Producto')),
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
                  Navigator.pushNamed(context, AppRoutes.productoListRoute);
                },
              ),
              Center(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.item.foto.toString(),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/nofoto.jpg'),
                      fit: BoxFit.cover,
                      height: 200,
                      width: 200,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: themeProvider.isDiurno
                        ? themeColors[2]
                        : themeColors[0],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                            _nombreController, 'Nombre', themeProvider),
                        SizedBox(height: 20),
                        _buildTextField(
                            _descripController, 'Descripcion', themeProvider),
                        SizedBox(height: 20),
                        _buildTextField(
                            _precioController, 'Precio', themeProvider),
                        SizedBox(height: 20),
                        _buildTextField(
                            _stockController, 'Stock', themeProvider),
                        SizedBox(height: 20),
                        _buildDropdownEstado(themeProvider),
                        SizedBox(height: 20),
                        _buildDropdownSubCategoria(themeProvider),
                      SizedBox(height: 20),
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
                          onPressed: _editarProducto,
                          child: Text('Actualizar Producto'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        color: themeProvider.isDiurno ? themeColors[7]: themeColors[2],
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
          child: Text(estado,
          style: TextStyle(color: Colors.blue),),
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
          child: Text(subCategoria['nombre'],
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
    );
  }
}
