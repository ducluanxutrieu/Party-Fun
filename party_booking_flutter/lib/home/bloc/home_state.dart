part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String message;
  final FormzStatus status;
  final List<MenuModel> listMenu;
  final bool showSearchField;
  final bool darkThemeEnabled;

  HomeState(
      {this.message,
      this.status = FormzStatus.pure,
      this.listMenu = const [],
      this.showSearchField = false,
      this.darkThemeEnabled = false});

  HomeState getListDish(
      {List<MenuModel> listMenu,
      FormzStatus status,
      String message,
      bool showSearchField,
      bool darkThemeEnabled}) {
    return HomeState(
      status: status ?? this.status,
      listMenu: listMenu ?? this.listMenu,
      message: message ?? this.message,
      showSearchField: showSearchField ?? this.showSearchField,
      darkThemeEnabled: darkThemeEnabled ?? this.darkThemeEnabled,
    );
  }

  @override
  List<Object> get props => [message, status, listMenu, showSearchField, darkThemeEnabled];
}
