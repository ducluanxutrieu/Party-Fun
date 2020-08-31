import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/menu_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/src/dish_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({DishRepository dishRepository})
      : assert(dishRepository != null),
        _dishRepository = dishRepository,
        super(HomeState());

  final DishRepository _dishRepository;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetListDishEvent:
        yield* _mapGetListDishEventToState(event, state);
        break;
      case OnSearchDishChangeEvent:
        yield* _mapSearchListDishEventToState(event, state);
        break;
      case OnSearchPressedEvent:
        yield state.getListDish(
            showSearchField: (event as OnSearchPressedEvent).showSearchField);
        break;
      case SetDarkThemeEvent:
        yield state.getListDish(
            darkThemeEnabled: (event as SetDarkThemeEvent).darkThemeEnabled);
        _saveDarkThemeToShared((event as SetDarkThemeEvent).darkThemeEnabled);
        break;
      default:
    }
  }

  // @override
  // Future<void> close() {
  //   // _dishRepository.dispose();
  //   return super.close();
  // }

  Stream<HomeState> _mapGetListDishEventToState(
      GetListDishEvent event, HomeState state) async* {
    bool darkThemeEnabled = await _getDarkTheme();
    yield state.getListDish(status: FormzStatus.submissionInProgress, darkThemeEnabled: darkThemeEnabled);
    try {
      List<DishModel> dishModels = await _dishRepository.getListDishes();
      List<Category> categories = await _dishRepository.getListCategories();
      List<MenuModel> listMenu = _menuAllocation(dishModels, categories);
      yield state.getListDish(
          status: FormzStatus.submissionSuccess, listMenu: listMenu);
//      yield state.getListDish(
//          status: FormzStatus.pure);
    } catch (cause) {
      yield state.getListDish(
          message: cause.toString(), status: FormzStatus.submissionFailure);
      print("&&&&&&&&&&&&&");
      print(cause.toString());
    }
  }

  Future<bool> _getDarkTheme() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool darkThemeEnabled = sharedPreferences.getBool(Constants.DARK_THEME_ENABLED);
    if(darkThemeEnabled == null) darkThemeEnabled = false;
    return darkThemeEnabled;
  }

  Stream<HomeState> _mapSearchListDishEventToState(
      OnSearchDishChangeEvent event, HomeState state) async* {
    if (event.searchText.isNotEmpty) {
      yield state.getListDish(status: FormzStatus.submissionInProgress);
      try {
        List<DishModel> dishModels =
            await _dishRepository.searchListDish(event.searchText);
        List<Category> categories =
            await _dishRepository.getListCategoriesFromDB();
        List<MenuModel> listMenu = _menuAllocation(dishModels, categories);
        yield state.getListDish(
            status: FormzStatus.submissionSuccess, listMenu: listMenu);
      } catch (cause) {
        yield state.getListDish(
            message: cause.toString(), status: FormzStatus.submissionFailure);
      }
    } else {
      try {
        List<DishModel> dishModels =
            await _dishRepository.getListDishesFromDB();
        List<Category> categories =
            await _dishRepository.getListCategoriesFromDB();
        List<MenuModel> listMenu = _menuAllocation(dishModels, categories);
        yield state.getListDish(
            status: FormzStatus.submissionSuccess, listMenu: listMenu);
      } catch (cause) {
        yield state.getListDish(
            message: cause.toString(), status: FormzStatus.submissionFailure);
      }
    }
  }

  List<MenuModel> _menuAllocation(
      List<DishModel> dishes, List<Category> categories) {
    var listMenu = List<MenuModel>();

    dishes.forEach((dish) {
      dish.categories.forEach((dishCategory) {
        categories.forEach((category) {
          if (dishCategory == category.name) {
            bool haveThisCate = false;
            listMenu.forEach((menu) {
              if (menu.menuName == category.name) {
                menu.listDish.add(dish);
                haveThisCate = true;
              }
            });
            if (!haveThisCate) {
              listMenu
                  .add(MenuModel(menuName: category.name, listDish: [dish]));
            }
          }
        });
      });
    });
    return listMenu;
  }

  Future<void> _saveDarkThemeToShared(bool darkThemeEnabled) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.DARK_THEME_ENABLED, darkThemeEnabled);
  }
}
