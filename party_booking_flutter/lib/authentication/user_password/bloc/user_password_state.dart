part of 'user_password_bloc.dart';

class UserPasswordState extends Equatable {
  const UserPasswordState._({this.status = FormzStatus.pure, this.message = ""});

  final FormzStatus status;
  final String message;

  const UserPasswordState.forgotPassword({FormzStatus status = FormzStatus.pure, String message})
      : this._(status: status, message: message);
  @override
  List<Object> get props => [status, message];
}
