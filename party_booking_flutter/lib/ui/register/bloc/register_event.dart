part of 'register_bloc.dart';


abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  RegisterSubmitted(this.registerModel);

  final RegisterRequestModel registerModel;

  @override
  List<Object> get props => [registerModel];
}
