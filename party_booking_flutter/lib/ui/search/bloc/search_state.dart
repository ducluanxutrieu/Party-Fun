part of 'search_bloc.dart';

class SearchState extends Equatable {
  final List<DishModel> listDishes;

  SearchState({this.listDishes = const []});

  SearchState search({List<DishModel> listDishes}) {
    return SearchState(listDishes: listDishes);
  }

  @override
  List<Object> get props => [listDishes];
}
