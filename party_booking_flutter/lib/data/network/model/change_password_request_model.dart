class ConfirmResetPasswordRequestModel {
  String code;
  String password;
  String username;

  ConfirmResetPasswordRequestModel(
      {this.code, this.password, this.username});

  static ConfirmResetPasswordRequestModel formJsonFactory(
          Map<String, dynamic> json) =>
      ConfirmResetPasswordRequestModel.fromJson(json);

  factory ConfirmResetPasswordRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ConfirmResetPasswordRequestModel(
          code: json["otp_code"],
          password: json["password"],
          username: json['username']);

  Map<String, dynamic> toJson() =>
      {"otp_code": code, "password": password, 'username': username};
}
