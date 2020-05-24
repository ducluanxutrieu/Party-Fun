class ConfirmChangePasswordRequestModel {

  String password;
  String new_password;

  ConfirmChangePasswordRequestModel(
      {  this.password, this.new_password});

  static ConfirmChangePasswordRequestModel formJsonFactory(
          Map<String, dynamic> json) =>
      ConfirmChangePasswordRequestModel.fromJson(json);

  factory ConfirmChangePasswordRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ConfirmChangePasswordRequestModel(

          password: json["password"],
          new_password: json['new_password']);

  Map<String, dynamic> toJson() =>
      { "password": password, 'new_password': new_password};
}
