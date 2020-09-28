part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String message;
  final FormzStatus status;
  final List<MenuModel> listMenu;
  final List<DishModel> listDishes;
  final List<Category> listCategories;
  final bool showSearchField;

  HomeState(
      {this.message,
      this.status = FormzStatus.pure,
      this.listMenu = const [],
      this.listDishes = const [],
      this.listCategories = const [],
      this.showSearchField = false,});

  HomeState getListMenu({
    List<MenuModel> listMenu,
    List<DishModel> listDishes,
    List<Category> listCategories,
    FormzStatus status,
    String message,
    bool showSearchField,
  }) {
    return HomeState(
      status: status ?? this.status,
      listMenu: listMenu ?? this.listMenu,
      listDishes: listDishes ?? this.listDishes,
      listCategories: listCategories ?? this.listCategories,
      message: message ?? this.message,
      showSearchField: showSearchField ?? this.showSearchField,
    );
  }

  HomeState getListDish({
    List<DishModel> listDishes,
    FormzStatus status,
    String message,
    bool showSearchField,
  }) {
    return HomeState(
      status: status ?? this.status,
      listMenu: this.listMenu,
      listDishes: listDishes ?? this.listDishes,
      message: message ?? this.message,
      showSearchField: showSearchField ?? this.showSearchField,
    );
  }

  @override
  List<Object> get props =>
      [message, status, listMenu, listDishes, listCategories, showSearchField];
}
