class ConfirmChangePasswordRequestModel {

  String password;
  String newPassword;

  ConfirmChangePasswordRequestModel(
      {  this.password, this.newPassword});

  static ConfirmChangePasswordRequestModel formJsonFactory(
          Map<String, dynamic> json) =>
      ConfirmChangePasswordRequestModel.fromJson(json);

  factory ConfirmChangePasswordRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ConfirmChangePasswordRequestModel(

          password: json["password"],
          newPassword: json['new_password']);

  Map<String, dynamic> toJson() =>
      { "password": password, 'new_password': newPassword};
}
