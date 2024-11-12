class AuthRequestModel {
  AuthRequestModel({
    required this.email,
    required this.password,
  });
  late final  String? email;
  late final  String? password;
 

  // AuthModel.dart({this.email, this.password});

  AuthRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    final _data = <String, dynamic>{};
    _data['email'] = this.email;
    _data['password'] = this.password;
    return _data;
  }
}
