import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:party_booking/cart/cart_repository.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';

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
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AddDishToCartEvent:
        yield _mapAddDishToCartEventToState(event, state);
        break;
      case RemoveDishToCartEvent:
        yield _mapRemoveDishToCartEventToState(event, state);
        break;
      case ClearCartEvent:
        yield _mapClearCartEventToState(event, state);
        break;
      case UpdateDishToCartEvent:
        yield _mapUpdateDishToCartEventToState(event, state);
        break;
      case BookClickedEvent:
        yield* _mapBookClickedEventToState(event, state);
        break;
      case GetPaymentEvent:
        yield* _mapGetPaymentEventToState(event, state);
        break;
      default:
        break;
    }
  }

  void calculateTotalBill() {
    totalCartValue = 0;
    cartList.forEach((cart) {
      totalCartValue += cart.priceNew * cart.quantity;
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

  CartState _mapAddDishToCartEventToState(
      AddDishToCartEvent event, CartState state) {
    bool isAdded = false;
    cartList.forEach((element) {
      if (element.id == event.dishModel.id) {
        element.quantity++;
        isAdded = true;
      }
    });
    if (!isAdded) {
      cartList.add(event.dishModel);
    }
    int totalItem = calculateTotalItem();
    calculateTotalBill();
    return CartState(
        carts: cartList, totalBillPrice: totalCartValue, totalItem: totalItem);
  }

  CartState _mapClearCartEventToState(ClearCartEvent event, CartState state) {
    cartList.clear();
    totalCartValue = 0;
    totalMoney = "0";
    return CartState(carts: [], totalBillPrice: 0, totalItem: 0);
  }

  CartState _mapRemoveDishToCartEventToState(
      AddDishToCartEvent event, CartState state) {
    cartList.removeWhere((element) => element.id == event.dishModel.id);
    int totalItem = calculateTotalItem();
    calculateTotalBill();
    return CartState(
        carts: cartList, totalBillPrice: totalCartValue, totalItem: totalItem);
  }

  CartState _mapUpdateDishToCartEventToState(
      UpdateDishToCartEvent event, CartState state) {
    if (event.isAdd) {
      cartList.forEach((element) {
        if (element.id == event.dishModel.id) {
          element.quantity++;
        }
      });
    } else {
      cartList.forEach((element) {
        if (element.id == event.dishModel.id && element.quantity > 1) {
          element.quantity--;
        }
      });
    }
    int totalItem = calculateTotalItem();
    calculateTotalBill();
    return CartState(
        carts: cartList, totalBillPrice: totalCartValue, totalItem: totalItem);
  }

  Stream<CartState> _mapBookClickedEventToState(
      BookClickedEvent event, CartState state) async* {
    yield state.bookParty(
        status: FormzStatus.submissionInProgress, message: "");
    try {
      List<ListDishes> listDishes = _getListDishes(state.carts);
      MapEntry<Bill, String> result = await _cartRepository.requestBookParty(
          cus: event.numberOfCustomer,
          day: event.partyDate,
          discountCode: event.discountCode,
          num: event.numberOfTable,
          listDish: listDishes);
      if (result.key != null) {
        yield state.bookParty(
            bill: result.key,
            message: result.value,
            status: FormzStatus.submissionSuccess);
        Future.delayed(Duration(microseconds: 300));
        yield state.bookParty(status: FormzStatus.pure);
      } else {
        yield state.bookParty(
            message: result.value, status: FormzStatus.submissionFailure);
        Future.delayed(Duration(microseconds: 300));
        yield state.bookParty(status: FormzStatus.pure);
      }
    } catch (cause) {
      yield state.bookParty(
          message: cause.toString(), status: FormzStatus.submissionFailure);
      Future.delayed(Duration(microseconds: 300));
      yield state.bookParty(status: FormzStatus.pure);
    }
  }

  List<ListDishes> _getListDishes(List<DishModel> list) {
    List<ListDishes> result = [];
    list.forEach((element) {
      result.add(ListDishes(id: element.id, numberDish: element.quantity));
    });
    return result;
  }

Stream<CartState> _mapGetPaymentEventToState(
      GetPaymentEvent event, CartState state) async* {
    String message = await _cartRepository.getPayment(event.bill);
    print(message);
    print('_____________');
  yield state.getPayment(messagePayment: message);
  }
}
