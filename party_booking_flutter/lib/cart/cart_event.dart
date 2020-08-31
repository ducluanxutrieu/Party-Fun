part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {}

class ClearCartEvent extends CartEvent {
  ClearCartEvent();

  @override
  List<Object> get props => [];
}

class BookEventClicked extends CartEvent {
  final DateTime partyDate;
  final int numberOfTable;
  final int numberOfCustomer;
  final String discountCode;

  BookEventClicked({@required this.partyDate,@required  this.numberOfTable,@required  this.numberOfCustomer,@required  this.discountCode});

  @override
  List<Object> get props => [partyDate, numberOfTable, numberOfCustomer, discountCode];
}

class AddDishToCartEvent extends CartEvent {
  final DishModel dishModel;

  AddDishToCartEvent(this.dishModel);

  @override
  List<Object> get props => [dishModel];
}

class RemoveDishToCartEvent extends CartEvent {
  final DishModel dishModel;

  RemoveDishToCartEvent(this.dishModel);

  @override
  List<Object> get props => [dishModel];
}

class UpdateDishToCartEvent extends CartEvent {
  final DishModel dishModel;
  final int quantity;

  UpdateDishToCartEvent(this.dishModel, this.quantity);

  @override
  List<Object> get props => [dishModel, quantity];
}