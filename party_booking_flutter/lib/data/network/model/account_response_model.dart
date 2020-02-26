class AccountResponseModel {
  bool success;
  String message;
  Account account;

  AccountResponseModel({this.success, this.message, this.account});

  AccountResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    account =
    json['account'] != null ? new Account.fromJson(json['account']) : null;
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

class Account {
  String fullName;
  String username;
  String email;
  int phoneNumber;
  String birthday;
  String sex;
  String role;
  String imageurl;
  String resetpassword;
  String createAt;
  String updateAt;
  String sId;

  Account(
      {this.fullName,
        this.username,
        this.email,
        this.phoneNumber,
        this.birthday,
        this.sex,
        this.role,
        this.imageurl,
        this.resetpassword,
        this.createAt,
        this.updateAt,
        this.sId});

  Account.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    birthday = json['birthday'];
    sex = json['sex'];
    role = json['role'];
    imageurl = json['imageurl'];
    resetpassword = json['resetpassword'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['birthday'] = this.birthday;
    data['sex'] = this.sex;
    data['role'] = this.role;
    data['imageurl'] = this.imageurl;
    data['resetpassword'] = this.resetpassword;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    data['_id'] = this.sId;
    return data;
  }
}