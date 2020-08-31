import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

/*  void calculateTotalBill() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.priceNew * f.quantity;
    });

    int i = int.parse(totalCartValue.toStringAsFixed(
        totalCartValue.truncateToDouble() == totalCartValue ? 0 : 2));
    final f = new NumberFormat("#,###");
    totalMoney = f.format(i);
  }

  int calculateTotalItem() {
    int totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.quantity;
    });

    return totalCartValue;
  }*/
}
