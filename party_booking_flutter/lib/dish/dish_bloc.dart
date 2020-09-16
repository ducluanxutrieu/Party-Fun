import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
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
      case GetListRatesEvent:
        yield* _mapGetListRatesEventToState(event, state);
        break;
      default:
        break;
    }
  }

  Stream<DishState> _mapGetListRatesEventToState(GetListRatesEvent event, DishState state) async* {
     MapEntry<String, bool> result = await dishRepository.getListRate(event.dishID, isStart: event.isStart);
     if(result.value){
       yield state.copyWith(messageRate: result.key, rateDataModel: dishRepository.rateDataModel);
     }else {
       yield state.copyWith(messageRate: result.key);
     }
  }
}
