part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnSearchDishChangeEvent extends SearchEvent {
  const OnSearchDishChangeEvent({this.searchText});
  final String searchText;

  @override
  List<Object> get props => [searchText];
}

class OnSearchPressedEvent extends SearchEvent {
  final bool showSearchField;

  OnSearchPressedEvent({this.showSearchField});

  @override
  List<Object> get props => [showSearchField];
}