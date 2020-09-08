part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<DishModel> carts;
  final double totalBillPrice;
  final int totalItem;
  final FormzStatus status;
  final String message;
  final Bill bill;
  final String messagePayment;

  CartState(
      {this.carts = const [],
      this.totalBillPrice = 0,
      this.totalItem = 0,
      this.status = FormzStatus.pure,
      this.message = "",
      this.bill,
      this.messagePayment = ""});

  CartState bookParty({FormzStatus status, String message, Bill bill}) {
    return CartState(
        carts: this.carts,
        bill: bill,
        message: message ?? this.message,
        status: status ?? this.status,
        totalBillPrice: this.totalBillPrice,
        totalItem: this.totalItem,
        messagePayment: this.messagePayment);
  }

  CartState getPayment({String messagePayment}) {
    return CartState(
        carts: this.carts,
        bill: this.bill,
        message: this.message,
        status: this.status,
        totalBillPrice: this.totalBillPrice,
        totalItem: this.totalItem,
        messagePayment: messagePayment ?? this.messagePayment);
  }

  @override
  List<Object> get props =>
      [carts, totalBillPrice, totalItem, status, message, bill];
}
