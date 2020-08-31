part of 'cart_bloc.dart';


class CartState extends Equatable {
  final List<CartModel> listCarts;
  final double totalBillPrice;
  final int totalItem;

  CartState({this.listCarts = const [], this.totalBillPrice = 0, this.totalItem = 0});

  @override
  List<Object> get props => [listCarts, totalBillPrice, totalItem];
}
