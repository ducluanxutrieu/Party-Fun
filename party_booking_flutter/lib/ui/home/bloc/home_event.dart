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

class GetListImageEvent extends HomeEvent {

}