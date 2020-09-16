part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;

  const LoginState(
      {this.status = FormzStatus.pure});

  LoginState copyWith({
    FormzStatus status,
  }) {
    return LoginState(
        status: status ?? this.status,);
  }

  @override
  List<Object> get props => [status];
}
