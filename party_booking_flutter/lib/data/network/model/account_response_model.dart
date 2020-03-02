class AccountResponseModel {
  bool success;
  String message;
  AccountModel account;

  AccountResponseModel({this.success, this.message, this.account});

  static AccountResponseModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountResponseModel.fromJson(json);

  AccountResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    account = json['account'] != null
        ? new AccountModel.fromJson(json['account'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    return data;
  }
}

class AccountModel {
  String id;
  String username;
  String fullName;
  String email;
  String phoneNumber;
  String birthday;
  String sex;
  String role;
  String imageurl;
  String resetpassword;
  String createAt;
  String updateAt;
  String token;

  AccountModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.birthday,
    this.sex,
    this.role,
    this.imageurl,
    this.resetpassword,
    this.createAt,
    this.updateAt,
    this.token,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json["id"]?? "jdfnj2e23r32",
        username: json["username"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        birthday: json["birthday"],
        sex: json["sex"],
        role: json["role"],
        imageurl: json["imageurl"],
        resetpassword: json["resetpassword"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "birthday": birthday,
        "sex": sex,
        "role": role,
        "imageurl": imageurl,
        "resetpassword": resetpassword,
        "createAt": createAt,
        "updateAt": updateAt,
        "token": token,
      };

  static AccountModel fromJsonFactory(Map<String, dynamic> json) =>
      AccountModel.fromJson(json);
}
