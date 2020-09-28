part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetListMenuEvent extends HomeEvent {
  const GetListMenuEvent();
}

class GetListDishEvent extends HomeEvent {
/*  final CategoryModel categoryModel;

  GetListDishEvent(this.categoryModel);*/
}

class OnPageChangeEvent extends HomeEvent {
  final int itemSelected;

  OnPageChangeEvent({this.itemSelected = 0});
}

class OnSearchDishChangeEvent extends HomeEvent {
  const OnSearchDishChangeEvent({this.searchText});
  final String searchText;

  @override
  List<Object> get props => [searchText];
}

class OnSearchPressedEvent extends HomeEvent {
  final bool showSearchField;

  OnSearchPressedEvent({this.showSearchField});

  @override
  List<Object> get props => [showSearchField];
}

class GetListImageEvent extends HomeEvent {

}