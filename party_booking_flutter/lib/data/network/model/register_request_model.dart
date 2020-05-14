class RegisterRequestModel {
  String fullName;
  String username;
  String email;
  String phoneNumber;
  String password;

  RegisterRequestModel(
      {this.fullName,
        this.username,
        this.email,
        this.phoneNumber,
        this.password});

  static RegisterRequestModel fromJsonFactory(Map<String, dynamic> json) =>
      RegisterRequestModel.fromJson(json);

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phoneNumber;
    data['password'] = this.password;
    return data;
  }
}
