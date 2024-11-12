// ignore: file_names
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/sheet_style.dart';
import 'package:front_flutter_api_rest/src/controller/auth/login_register.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthModel.dart';
import 'package:front_flutter_api_rest/src/services/sheet_exel.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:http/http.dart' as http;
import 'package:front_flutter_api_rest/src/providers/provider.dart';

class UsuarioController {
  static const _scopes = [SheetsApi.spreadsheetsScope];
  final _sheetName = 'USUARIOS';
  final String _spreadsheetId = ExelSheet.hojaExelProyecto;

  UsuarioController() {
    _init();
  }
  void _init() {
    LoginRegisterController.userCreatedStream.listen(
      (userData) {
        print("Usuario escuchado: $userData");
        _agregarUsuarioEnHoja(userData);
      },
      onError: (error) {
        print("Error al escuchar el stream: $error");
      },
    );
  }

  Future<AutoRefreshingAuthClient> _getAuthClient() async {
    final credentialsJson =
        await rootBundle.loadString('assets/credencial_sheet.json');
    final accountCredentials =
        ServiceAccountCredentials.fromJson(json.decode(credentialsJson));
    return clientViaServiceAccount(accountCredentials, _scopes);
  }

  Future<int?> _getSheetIdByName(SheetsApi sheetsApi, String sheetName) async {
    try {
      Spreadsheet spreadsheet =
          await sheetsApi.spreadsheets.get(_spreadsheetId);
      for (var sheet in spreadsheet.sheets!) {
        if (sheet.properties!.title == sheetName) {
          return sheet.properties!.sheetId;
        }
      }
    } catch (e) {
      print('Error al obtener el ID de la hoja: $e');
    }
    return null;
  }

  Future<void> formato_Hoja_encabezado() async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);

    final sheetStyle = SheetStyle([
      'ID',
      'Email',
      'Nombre',
      'Apellido Paterno',
      'Apellido Materno',
      'DNI',
      'Codigo',
      'Rol',
      'Imagen',
    ]);
    final range = '$_sheetName!A1:I1';

    final sheetId = await _getSheetIdByName(sheetsApi, _sheetName);

    if (sheetId == null) {
      print('No se encontró la hoja con nombre $_sheetName');
      return;
    }

    ValueRange response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);

    if (response.values == null || response.values!.isEmpty) {
      ValueRange headerRow = ValueRange.fromJson({
        'values': [sheetStyle.headerRow]
      });

      await sheetsApi.spreadsheets.values.update(
        headerRow,
        _spreadsheetId,
        range,
        valueInputOption: 'USER_ENTERED',
      );

      print("Encabezado creado en A1.");
    } else {
      print("A1 ya tiene contenido, no se puede insertar el encabezado.");
    }

    final formatRequest = sheetStyle.getColumnFormatRequest(sheetId!);
    await sheetsApi.spreadsheets.batchUpdate(formatRequest, _spreadsheetId);
  }

  Future<List<String>> _getAllIds() async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);
    final range = '$_sheetName!A:A';
    ValueRange response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    List<String> ids = [];
    if (response.values != null) {
      for (var row in response.values!) {
        if (row.isNotEmpty) {
          ids.add(row[0] as String);
        }
      }
    }
    return ids;
  }

  Future<void> listarItem() async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);

    final range = '$_sheetName!A2:G';

    try {
      ValueRange response =
          await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
      List<List<dynamic>> values = response.values!;

      if (values.isEmpty) {
        print('No hay items registrados.');
      } else {
        print('Items Registrados:');
        values.forEach((row) {
          print(' - ${row.join(', ')}');
        });
      }
    } catch (e) {
      print('Error al obtener eventos desde Google Sheets: $e');
    }
  }

  Future<void> _addRow(List<String> row) async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);
    final range = '$_sheetName!A2';

    ValueRange vr = ValueRange.fromJson({
      'values': [row]
    });

    await sheetsApi.spreadsheets.values
        .append(vr, _spreadsheetId, range, valueInputOption: 'USER_ENTERED');
  }

  Future<void> _updateRow(int rowIndex, List<String> row) async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);
    final range = '$_sheetName!A${rowIndex + 1}';

    ValueRange vr = ValueRange.fromJson({
      'values': [row]
    });

    await sheetsApi.spreadsheets.values
        .update(vr, _spreadsheetId, range, valueInputOption: 'USER_ENTERED');
  }

  Future<void> _deleteRow(int rowIndex) async {
    final authClient = await _getAuthClient();
    final sheetsApi = SheetsApi(authClient);

    final sheetId = await _getSheetIdByName(sheetsApi, _sheetName);
    if (sheetId == null) {
      print('No se encontró la hoja con nombre $_sheetName');
      return;
    }
    try {
      BatchUpdateSpreadsheetRequest batchUpdateRequest =
          BatchUpdateSpreadsheetRequest.fromJson({
        'requests': [
          {
            'deleteDimension': {
              'range': {
                'sheetId': sheetId,
                'dimension': 'ROWS',
                'startIndex': rowIndex,
                'endIndex': rowIndex + 1
              }
            }
          }
        ]
      });

      await sheetsApi.spreadsheets
          .batchUpdate(batchUpdateRequest, _spreadsheetId);
    } catch (e) {
      print('Error al eliminar fila desde Google Sheets: $e');
    }
  }

  Future<List<dynamic>> getDataUsuario({String? name}) async {
    try {
      final urls = Providers.provider();
      String urlString = urls['userListProvider']!;

      if (name != null && name.isNotEmpty) {
        urlString += '/buscar?name=$name';
      }

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<http.Response> crearUsuario(UsuarioModel nuevoUsuario) async {
    final urls = Providers.provider();
    final urlString = urls['registerProvider']!;
    final url = Uri.parse(urlString);
    final body = jsonEncode(nuevoUsuario.toJson());
    await formato_Hoja_encabezado();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      if (responseBody.containsKey('user')) {
        final nuevoUsuarioCreado = UsuarioModel.fromJson(responseBody['user']);
        if (nuevoUsuarioCreado.id != null) {
          print('Usuario creado con ID: ${nuevoUsuarioCreado.id}');
          String hyperlinkFormula =
              '=HYPERLINK("${nuevoUsuarioCreado.foto}", "linkDeImagen")';
          await _addRow([
            nuevoUsuarioCreado.id.toString(),
            nuevoUsuarioCreado.email.toString(),
            nuevoUsuarioCreado.name.toString(),
            nuevoUsuarioCreado.apellido_p.toString(),
            nuevoUsuarioCreado.apellido_m.toString(),
            nuevoUsuarioCreado.dni.toString(),
            nuevoUsuarioCreado.codigo.toString(),
            nuevoUsuarioCreado.role.toString(),
            hyperlinkFormula,
          ]);
        } else {
          print("Error: el ID del usuario no se pudo extraer de la respuesta.");
        }
      } else {
        print("Error: la respuesta no contiene el objeto 'user'.");
      }
    } else {
      print(
          'Error al crear Usuario: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<void> _agregarUsuarioEnHoja(Map<String, dynamic> userData) async {
    await formato_Hoja_encabezado();

    String hyperlinkFormula =
        '=HYPERLINK("${userData['foto']}", "linkDeImagen")';

    List<String> row = [
      userData['id'].toString(),
      userData['email'].toString() ?? 'no hay email',
      userData['name'].toString() ?? 'no hay name',
      userData['apellido_p'].toString() ?? 'no hay apellido p',
      userData['apellido_m'].toString() ?? 'no hay apellido m',
      userData['dni'].toString() ?? 'no hay dni',
      userData['codigo'].toString() ?? 'no hay codigo',
      userData['role'].toString() ?? 'no hay role',
      hyperlinkFormula ?? 'no hay foto',
    ];
    await _addRow(row);
  }

  Future<http.Response> editarUsuario(UsuarioModel usuarioEditado) async {
    final urls = Providers.provider();
    final urlString = urls['authUserListProvider']!;
    final url = Uri.parse(urlString);

    final body = jsonEncode(usuarioEditado.toJson());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      List<String> ids = await _getAllIds();
      int rowIndex = ids.indexOf(usuarioEditado.id.toString());
      print('usuario editado: ${response.body}');

      if (rowIndex != -1) {
        String hyperlinkFormula =
            '=HYPERLINK("${usuarioEditado.foto}", "linkDeImagen")';

        List<String> newRow = [
          usuarioEditado.id.toString(),
          usuarioEditado.email.toString(),
          usuarioEditado.name.toString(),
          usuarioEditado.apellido_p.toString(),
          usuarioEditado.apellido_m.toString(),
          usuarioEditado.dni.toString(),
          usuarioEditado.codigo.toString(),
          usuarioEditado.role.toString(),
          hyperlinkFormula,
        ];
        await _updateRow(rowIndex, newRow);
      } else {
        print("ID no encontrado: ${usuarioEditado.id}");
      }
    } else {
      print(
          'Error al editar usuario: ${response.statusCode} - ${response.body}');
    }

    return response;
  }

  Future<http.Response> removeUsuario(int id, String fotoURL) async {
    final urls = Providers.provider();
    final urlString = urls['authUserListProvider']!;
    final url = Uri.parse('$urlString/delete/$id');

    var response = await http.delete(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (fotoURL.isNotEmpty &&
        (fotoURL.startsWith('gs://') || fotoURL.startsWith('https://'))) {
      try {
        await FirebaseStorage.instance.refFromURL(fotoURL).delete();
        print("Imagen eliminada de Firebase Storage");
      } catch (e) {
        print("Error al eliminar la imagen: $e");
      }
    }

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 204) {
      List<String> ids = await _getAllIds();

      int rowIndex = ids.indexOf(id.toString());

      if (rowIndex != -1) {
        await _deleteRow(rowIndex);
      } else {
        print("ID no encontrado en Google Sheets: $id");
      }
    } else {
      print(
          'Error al eliminar sub categoría: ${response.statusCode} - ${response.body}');
    }
    return response;
  }
}
