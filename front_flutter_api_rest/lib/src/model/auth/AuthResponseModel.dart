import 'dart:convert';

AuthResponseModel authResponseJson(String str) =>
AuthResponseModel.fromJson(json.decode(str));
class AuthResponseModel {
  String? token;
  User? user;

  AuthResponseModel({this.token, this.user});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? role;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  String? foto;
  String? apellidoP;
  String? apellidoM;
  String? dni;
  String? codigo;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.role,
      this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.foto,
      this.apellidoP,
      this.apellidoM,
      this.dni,
      this.codigo,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    foto = json['foto'];
    apellidoP = json['apellido_p'];
    apellidoM = json['apellido_m'];
    dni = json['dni'];
    codigo = json['codigo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['foto'] = this.foto;
    data['apellido_p'] = this.apellidoP;
    data['apellido_m'] = this.apellidoM;
    data['dni'] = this.dni;
    data['codigo'] = this.codigo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}