class ChangePasswordRequestModel {
  String username;

  ChangePasswordRequestModel({this.username});

  static ChangePasswordRequestModel fromJsonFactory(
          Map<String, dynamic> json) =>
      ChangePasswordRequestModel.fromJson(json);

  ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    return data;
  }
}

class ConfirmResetPasswordRequestModel {
  String code;
  String passwordNew;

  ConfirmResetPasswordRequestModel({
    this.code,
    this.passwordNew,
  });

  static ConfirmResetPasswordRequestModel formJsonFactory(
          Map<String, dynamic> json) =>
      ConfirmResetPasswordRequestModel.fromJson(json);

  factory ConfirmResetPasswordRequestModel.fromJson(
          Map<String, dynamic> json) =>
      ConfirmResetPasswordRequestModel(
        code: json["resetpassword"],
        passwordNew: json["passwordnew"],
      );

  Map<String, dynamic> toJson() => {
        "resetpassword": code,
        "passwordnew": passwordNew,
      };
}
