part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {}

class ClearCartEvent extends CartEvent {
  ClearCartEvent();

  @override
  List<Object> get props => [];
}

class BookClickedEvent extends CartEvent {
  final DateTime partyDate;
  final int numberOfTable;
  final int numberOfCustomer;
  final String discountCode;

  BookClickedEvent(
      {@required this.partyDate,
      @required this.numberOfTable,
      @required this.numberOfCustomer,
      @required this.discountCode});

  @override
  List<Object> get props =>
      [partyDate, numberOfTable, numberOfCustomer, discountCode];
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
  final bool isAdd;

  UpdateDishToCartEvent(this.dishModel, this.isAdd);

  @override
  List<Object> get props => [dishModel, isAdd];
}

class GetPaymentEvent extends CartEvent {
  final Bill bill;

  GetPaymentEvent(this.bill);

  @override
  List<Object> get props => [bill];
}
