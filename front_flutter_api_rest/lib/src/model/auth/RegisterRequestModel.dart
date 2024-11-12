class RegisterRequestModel {
  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  late final  String? email;
  late final  String? password;
  late final  String? confirmPassword;
 

  // AuthModel.dart({this.email, this.password});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    // final Map<String, dynamic> data = new Map<String, dynamic>();
    final _data = <String, dynamic>{};
    _data['email'] = this.email;
    _data['password'] = this.password;
    _data['confirmPassword'] = this.confirmPassword;
    return _data;
  }
}
