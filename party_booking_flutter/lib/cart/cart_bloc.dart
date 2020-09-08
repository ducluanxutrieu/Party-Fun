import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/cart/cart_repository.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({@required CartRepository cartRepository})
      : assert(cartRepository != null),
        _cartRepository = cartRepository,
        super(CartState());

  final CartRepository _cartRepository;
  final List<DishModel> cartList = [];
  double totalCartValue = 0;
  String totalMoney;

  @override
  Stream<CartState> mapEventToState(CartEvent event,) async* {
    switch (event.runtimeType) {
      case AddDishToCartEvent:
        yield _mapAddDishToCartEventToState(event, state);
        break;
      case RemoveDishToCartEvent:
        yield* _mapRemoveDishToCartEventToState(event, state);
        break;
      case UpdateDishToCartEvent:
        yield* _mapUpdateDishToCartEventToState(event, state);
        break;
      case BookEventClicked:
        yield* _mapBookClickedEventToState(event, state);
        break;
      default: break;
    }
  }

  void calculateTotalBill() {
    totalCartValue = 0;
    cartList.forEach((f) {
      totalCartValue += f.priceNew * f.quantity;
    });

    int i = int.parse(totalCartValue.toStringAsFixed(
        totalCartValue.truncateToDouble() == totalCartValue ? 0 : 2));
    final f = new NumberFormat("#,###");
    totalMoney = f.format(i);
  }

  int calculateTotalItem() {
    int totalCartValue = 0;
    cartList.forEach((f) {
      totalCartValue += f.quantity;
    });

    return totalCartValue;
  }


  CartState _mapAddDishToCartEventToState(AddDishToCartEvent event,
      CartState state) {
    cartList.add(event.dishModel);
    int totalItem =  calculateTotalItem();
    calculateTotalBill();
    return CartState(carts: cartList, totalBillPrice: totalCartValue, totalItem: totalItem);
  }

  Stream<CartState> _mapRemoveDishToCartEventToState(AddDishToCartEvent event,
      CartState state) async* {

  }

  Stream<CartState> _mapUpdateDishToCartEventToState(AddDishToCartEvent event,
      CartState state) async* {

  }

  Stream<CartState> _mapBookClickedEventToState(AddDishToCartEvent event,
      CartState state) async* {

  }

}
