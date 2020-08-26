part of 'user_password_bloc.dart';

class UserPasswordState extends Equatable {
  const UserPasswordState({
    this.status = FormzStatus.pure,
    this.message = "",
    this.password,
    this.passMessage,
    this.newPassword,
    this.retypePassword,
    this.newPassMessage,
    this.retypePassMess,
  });

  final FormzStatus status;
  final String message;
  final String password;
  final String passMessage;
  final String newPassword;
  final String retypePassword;
  final String newPassMessage;
  final String retypePassMess;

  UserPasswordState changePassword({
    FormzStatus status,
    String message,
    String password,
    String passMessage,
    String newPassword,
    String retypePassword,
    String newPassMessage,
    String retypePassMess,
  }) {
    return UserPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      password: password ?? this.password,
      passMessage: passMessage ?? this.passMessage,
      newPassword: newPassword ?? this.newPassword,
      retypePassword: retypePassword ?? this.retypePassword,
      newPassMessage: newPassMessage ?? this.newPassMessage,
      retypePassMess: retypePassMess ?? this.retypePassMess,
    );
  }

  const UserPasswordState.forgotPassword(
      {FormzStatus status = FormzStatus.pure, String message})
      : this(status: status, message: message);

  @override
  List<Object> get props => [
        status,
        message,
        password,
        passMessage,
        newPassword,
        retypePassword,
        newPassMessage,
      ];
}

class ForgotPasswordState extends UserPasswordState {
  final FormzStatus status;
  final String message;

  const ForgotPasswordState({this.status, this.message})
      : super.forgotPassword();
}

/*class ChangePasswordState extends UserPasswordState {
  final FormzStatus status;
  final String message;
  final String password;
  final String newPassword;
  final String retypePassword;

  const ChangePasswordState(
      {this.status,
      this.password,
      this.newPassword,
      this.retypePassword,
      this.message});

  ChangePasswordState copyWith({
    FormzStatus status,
    String password,
    String newPassword,
    String retypePassword,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      password: password ?? this.password,
      newPassword: newPassword ?? this.newPassword,
      retypePassword: retypePassword ?? this.retypePassword,
    );
  }
}*/

/*class UserPasswordStateInitial extends UserPasswordState {
  final FormzStatus status;
  final String message;
  final String password;
  final String newPassword;

  const UserPasswordStateInitial(
      {this.status, this.message, this.password, this.newPassword})
      : super();
}*/
