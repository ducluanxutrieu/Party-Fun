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

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    return data;
  }
}