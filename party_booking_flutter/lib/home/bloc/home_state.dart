part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String message;
  final FormzStatus status;
  final List<MenuModel> listMenu;

  HomeState({this.message, this.status = FormzStatus.pure, this.listMenu = const []});

  HomeState getListDish(
      {List<MenuModel> listMenu, FormzStatus status, String message}) {
    return HomeState(
        status: status ?? this.status,
        listMenu: listMenu ?? this.listMenu,
        message: message ?? this.message);
  }

  @override
  List<Object> get props => [message, status, listMenu];
}
