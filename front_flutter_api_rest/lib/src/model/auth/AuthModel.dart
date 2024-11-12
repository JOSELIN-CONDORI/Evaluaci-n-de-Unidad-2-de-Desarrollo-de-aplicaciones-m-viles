class UsuarioModel {
  int? id;
  String? foto;
  String? role;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  String? apellido_p;
  String? apellido_m;
  String? dni;
  String? codigo;
  String? created_at;
  String? updated_at;
  
  UsuarioModel(
      {this.id,
      this.foto,
      this.role,
      this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.apellido_p,
      this.apellido_m,
      this.dni,
      this.codigo,
      this.created_at,
      this.updated_at});

  
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int?,
      foto: json['foto'] as String?,
      role: json['role'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      confirmPassword: json['confirmPassword'] as String?,
      apellido_p: json['apellido_p'] as String?,
      apellido_m: json['apellido_m'] as String?,
      dni: json['dni'] as String?,
      codigo: json['codigo'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foto': foto,
      'role': role,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'apellido_p': apellido_p,
      'apellido_m': apellido_m,
      'dni': dni,
      'codigo': codigo,
    };
  }
}
