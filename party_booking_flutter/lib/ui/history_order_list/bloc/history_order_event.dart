part of 'history_order_bloc.dart';

abstract class HistoryOrderEvent extends Equatable {
  const HistoryOrderEvent();

  @override
  List<Object> get props => [];
}

class GetListOrderEvent extends HistoryOrderEvent {
  final bool isRefresh;

  GetListOrderEvent(this.isRefresh);

  @override
  List<Object> get props => [isRefresh];
}
