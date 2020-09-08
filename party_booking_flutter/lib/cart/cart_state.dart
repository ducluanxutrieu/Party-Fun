part of 'cart_bloc.dart';


class CartState extends Equatable {
  final List<DishModel> carts;
  final double totalBillPrice;
  final int totalItem;

  CartState({this.carts = const [], this.totalBillPrice = 0, this.totalItem = 0});

//   CartState updateCart({
//     final List<CartModel> listCarts,
//     final double totalBillPrice,
//     final int totalItem,
// }){
//     return CartState
//   }

  @override
  List<Object> get props => [carts, totalBillPrice, totalItem];
}
