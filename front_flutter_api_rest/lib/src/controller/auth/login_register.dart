import 'dart:async';
import 'dart:convert';

import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthRequestModel.dart';
import 'package:front_flutter_api_rest/src/model/auth/AuthResponseModel.dart';
import 'package:front_flutter_api_rest/src/model/auth/RegisterRequestModel.dart';
import 'package:front_flutter_api_rest/src/model/auth/RegisterResponseModel.dart';
import 'package:front_flutter_api_rest/src/providers/provider.dart';

import 'package:http/http.dart' as http;

class LoginRegisterController {
  static var client = http.Client();
  static final StreamController<Map<String, dynamic>> _userCreatedController =
      StreamController<Map<String, dynamic>>.broadcast();

  static final Set<int> _emittedUserIds = {};

  static Stream<Map<String, dynamic>> get userCreatedStream =>
      _userCreatedController.stream;

  static Future<bool> login(AuthRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var urls = Providers.provider();
    var urlString = urls['loginProvider']!;
    var url = Uri.parse(urlString);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200) {
      final authResponse = authResponseJson(response.body);

      print('Token obtenido en el inicio de sesión: ${authResponse.token}');
      final userAsString = authResponse.user != null
          ? authResponse.user!.toJson().toString()
          : "Usuario no disponible";
      print('Usuario obtenido en el inicio de sesión: $userAsString');
      await ShareApiTokenController.setLoginDetails(authResponse);

      return true;
    } else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var urls = Providers.provider();
    var urlString = urls['registerProvider']!;
    var url = Uri.parse(urlString);

    try {
      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      var registerResponse = registerResponseModel(response.body);

      if (registerResponse.user == null) {
        print('No hay items registrados. ${registerResponse.toString()}');
      } else {
        print('Items Registrados: ${registerResponse.toString()}');
        int userId = registerResponse.user!.id ?? -1;
        if (!_emittedUserIds.contains(userId)) {
          final user = registerResponse.user!.toJson();
          _userCreatedController.add(user);
          _emittedUserIds.add(userId);
          print("Evento de creación de usuario emitido: $user");
        } else {
          print("El usuario ya ha sido emitido, no se vuelve a emitir.");
        }
      }

      return registerResponse;
    } catch (error) {
      throw Exception("Error en el registro: $error");
    }
  }

  static void dispose() {
    _userCreatedController.close();
  }

  static Future<List<String>> getUserProfile() async {
    var loginDetails = await ShareApiTokenController.loginDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ${loginDetails!.token}',
    };
    var urls = Providers.provider();
    var urlString = urls['userListProvider']!;
    var url = Uri.parse(urlString);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<String> emails = jsonData.map((dynamic item) {
        return item["email"].toString();
      }).toList();

      return emails;
    } else {
      return [];
    }
  }
}
