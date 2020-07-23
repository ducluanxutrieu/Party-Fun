part of 'login_bloc.dart';

class LoginState extends Equatable {
 final AppButtonState state;
 final AccountModel accountModel;
 final List<Category> categories;
  const LoginState({this.state, this.accountModel, this.categories});

  @override
  List<Object> get props => [state];
}