import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/src/dish_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.dishRepository) : super(SearchState(listDishes: []));

  final DishRepository dishRepository;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    switch(event.runtimeType){
      case OnSearchDishChangeEvent:
        yield* _mapSearchListDishEventToState(event, state);
        break;
    }
  }

  Stream<SearchState> _mapSearchListDishEventToState(
      OnSearchDishChangeEvent event, SearchState state) async* {
    if (event.searchText.isNotEmpty) {
      // yield state.getListMenu(status: FormzStatus.submissionInProgress);
      try {
        List<DishModel> dishModels =
        await dishRepository.searchListDish(event.searchText);
        yield state.search(listDishes: dishModels);
      } catch (cause) {
        yield state.search(listDishes: []);
      }
    } else {
      yield state.search(listDishes: []);
    }
  }
}
