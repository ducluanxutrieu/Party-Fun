part of 'user_password_bloc.dart';

abstract class UserPasswordEvent extends Equatable {
  const UserPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitted extends UserPasswordEvent {
  final String username;

  ForgotPasswordSubmitted(this.username);

  @override
  List<Object> get props => [username];
}
