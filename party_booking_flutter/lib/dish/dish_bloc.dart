import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/src/dish_repository.dart';

part 'dish_event.dart';
part 'dish_state.dart';

class DishBloc extends Bloc<DishEvent, DishState> {
  DishBloc(this.dishRepository) : super(DishState());

  final DishRepository dishRepository;

  @override
  Stream<DishState> mapEventToState(
    DishEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetListImageEvent:
        MapEntry result = await dishRepository.loadAssets();
        yield state.copyWith(
            listNewImage: result.key, messageListNewImage: result.value);
        break;
      default:
        break;
    }
  }
}
