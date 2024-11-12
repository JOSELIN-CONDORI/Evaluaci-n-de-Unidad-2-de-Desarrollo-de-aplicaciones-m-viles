import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.message,
    required this.user,
  });
  late final String message;
  late final User? user;

  RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('message')) {
      message = json['message'];
    } else {
      message = 'Mensaje no encontrado';
    }
    user = json.containsKey('user') ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['user'] = user!.toJson();
    return _data;
  }

  @override
  String toString() {
    return 'RegisterResponseModel { mensaje: $message, usuario: ${user != null ? user.toString() : "No registrado"} }';
  }
}

class User {
  int? id;
  String? email;
  String? password;
  String? confirmPassword;

  User({this.id, this.email, this.password, this.confirmPassword});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }

  @override
  String toString() {
    return 'User { id: $id, email: $email, password: $password, confirmPassword: $confirmPassword }';
  }
}
