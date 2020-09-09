import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/screen/history_order_list/bloc/history_order_repository.dart';

part 'history_order_event.dart';
part 'history_order_state.dart';

class HistoryOrderBloc extends Bloc<HistoryOrderEvent, HistoryOrderState> {
  HistoryOrderBloc({@required HistoryOrderRepository historyOrderRepository})
      : assert(historyOrderRepository != null),
        _historyOrderRepository = historyOrderRepository,
        super(HistoryOrderState()) {
    add(GetListOrderEvent(false));
  }

  final HistoryOrderRepository _historyOrderRepository;

  @override
  Stream<HistoryOrderState> mapEventToState(
    HistoryOrderEvent event,
  ) async* {
    if (event is GetListOrderEvent) {
      MapEntry<List<UserCart>, String> result = await _historyOrderRepository
          .getHistoryBooking(isRefresh: event.isRefresh);
      yield state.getListOrdered(
          message: result.value,
          listOrdered: result.key,
          currentPage: _historyOrderRepository.currentPage,
          totalPage: _historyOrderRepository.currentPage);
    }
  }
}
