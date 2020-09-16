part of 'register_bloc.dart';


class RegisterState extends Equatable {
  final FormzStatus status;
  final RegisterRequestModel registerModel;

  const RegisterState({this.status = FormzStatus.pure, this.registerModel});

  RegisterState copyWith({
    FormzStatus status,
    RegisterRequestModel registerModel
  }) {
    return RegisterState(
        status: status ?? this.status,
      registerModel: registerModel ?? this.registerModel,
    );
  }

  @override
  List<Object> get props => [status, registerModel];
}


