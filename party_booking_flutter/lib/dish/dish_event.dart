part of 'dish_bloc.dart';

@immutable
abstract class DishEvent {}

class GetListImageEvent extends DishEvent{}

class GetListRatesEvent extends DishEvent{
  final String dishID;
  final bool isStart;

  GetListRatesEvent(this.dishID, this.isStart);
}
