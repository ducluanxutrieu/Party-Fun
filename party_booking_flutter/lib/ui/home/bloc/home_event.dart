part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetListDishEvent extends HomeEvent {
  const GetListDishEvent();
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