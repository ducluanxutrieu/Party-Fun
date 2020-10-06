part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String message;
  final FormzStatus status;
  final List<MenuModel> listMenu;
  final List<DishModel> listDishes;
  final List<Category> listCategories;
  final bool showSearchField;
  final int selectedPage;

  HomeState({
    this.message,
    this.status = FormzStatus.pure,
    this.listMenu = const [],
    this.listDishes = const [],
    this.listCategories = const [],
    this.showSearchField = false,
    this.selectedPage = 0,
  });

  HomeState changePageSelected(int selectedPage) {
    return HomeState(
      status: this.status,
      listMenu: this.listMenu,
      listDishes: this.listDishes,
      listCategories: this.listCategories,
      message: this.message,
      showSearchField: this.showSearchField,
      selectedPage: selectedPage,
    );
  }

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
      selectedPage: this.selectedPage,
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
      selectedPage: this.selectedPage
    );
  }

  @override
  List<Object> get props =>
      [message, status, listMenu, listDishes, listCategories, showSearchField, selectedPage];
}
