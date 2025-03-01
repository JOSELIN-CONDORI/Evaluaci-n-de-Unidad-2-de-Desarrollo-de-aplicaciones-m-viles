// ignore: file_names
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter_api_rest/src/components/sheet_style.dart';
import 'package:front_flutter_api_rest/src/model/productoModel.dart';
import 'package:front_flutter_api_rest/src/services/sheet_exel.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:front_flutter_api_rest/src/providers/provider.dart';

class ProductoController {
  static const _scopes = [SheetsApi.spreadsheetsScope];
  final _sheetName = 'PRODUCTOS';
  final String _spreadsheetId = ExelSheet.hojaExelProyecto;

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
      'Nombre',
      'Descripción',
      'Precio',
      'Stock',
      'Estado',
      'Sub categoria',
      'Imagen',
    ]);
    final range = '$_sheetName!A1:H1';

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

  Future<List<dynamic>> getDataProductos({String? nombre}) async {
    try {
      final urls = Providers.provider();
      String urlString = urls['productoListProvider']!;

      if (nombre != null && nombre.isNotEmpty) {
        urlString += '/buscar?nombre=$nombre';
      }

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load Productos');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<http.Response> crearProducto(ProductoModel nuevoProducto) async {
    final urls = Providers.provider();
    final urlString = urls['productoListProvider']!;
    final url = Uri.parse(urlString);
    final body = jsonEncode(nuevoProducto.toJson());
    await formato_Hoja_encabezado();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final nuevoProductoCreado =
          ProductoModel.fromJson(json.decode(response.body));
      print('Producto creado: ${response.body}');
      String hyperlinkFormula =
          '=HYPERLINK("${nuevoProductoCreado.foto}", "linkDeImagen")';
      await _addRow([
        nuevoProductoCreado.id.toString(),
        nuevoProducto.nombre.toString(),
        nuevoProducto.descrip.toString(),
        nuevoProducto.precio.toString(),
        nuevoProducto.stock.toString(),
        nuevoProducto.estado.toString(),
        nuevoProducto.subCategoria?['id'],
        hyperlinkFormula,
      ]);
    } else {
      print(
          'Error al crear producto: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> editarProducto(ProductoModel productoEditado) async {
    final urls = Providers.provider();
    final urlString = urls['productoListProvider']!;
    final url = Uri.parse(urlString);

    final body = jsonEncode(productoEditado.toJson());

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      List<String> ids = await _getAllIds();
      int rowIndex = ids.indexOf(productoEditado.id.toString());
      print('producto editado: ${response.body}');

      if (rowIndex != -1) {
        String hyperlinkFormula =
            '=HYPERLINK("${productoEditado.foto}", "linkDeImagen")';

        List<String> newRow = [
          productoEditado.id.toString(),
          productoEditado.nombre.toString(),
          productoEditado.descrip.toString(),
          productoEditado.precio.toString(),
          productoEditado.stock.toString(),
          productoEditado.estado.toString(),
          productoEditado.subCategoria?['id'],
          hyperlinkFormula,
        ];
        await _updateRow(rowIndex, newRow);
      } else {
        print("ID no encontrado: ${productoEditado.id}");
      }
    } else {
      print(
          'Error al editar producto: ${response.statusCode} - ${response.body}');
    }

    return response;
  }

  Future<http.Response> removeProducto(int id, String fotoURL) async {
    final urls = Providers.provider();
    final urlString = urls['productoListProvider']!;
    final url = Uri.parse('$urlString/$id');

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
