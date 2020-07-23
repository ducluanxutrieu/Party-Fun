part of 'login_bloc.dart';

class LoginEvent{
  final String username;
  final String password;


  LoginEvent({
   @required this.username,@required this.password,
});

  @override
  List<Object> get props => [username, password];
}