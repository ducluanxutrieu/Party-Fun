part of 'user_password_bloc.dart';

abstract class UserPasswordEvent extends Equatable {
  const UserPasswordEvent();

  @override
  List<Object> get props => [];
}

class UserPasswordChanged extends UserPasswordEvent {
  const UserPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class UserNewPasswordChanged extends UserPasswordEvent {
  const UserNewPasswordChanged(this.newPassword);

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

class UserRetypePasswordChanged extends UserPasswordEvent {
  const UserRetypePasswordChanged(this.retypePassword);

  final String retypePassword;

  @override
  List<Object> get props => [retypePassword];
}

class ChangePasswordSubmitted extends UserPasswordEvent {
  final bool isChangePassword;
  final String username;

  ChangePasswordSubmitted({this.isChangePassword, this.username});
}

class ForgotPasswordSubmitted extends UserPasswordEvent {
  final String username;

  ForgotPasswordSubmitted(this.username);

  @override
  List<Object> get props => [username];
}
