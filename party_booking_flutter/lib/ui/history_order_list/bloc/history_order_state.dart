part of 'history_order_bloc.dart';

class HistoryOrderState extends Equatable {
  HistoryOrderState(
      {this.message = "",
      this.listOrdered,
      this.currentPage = 0,
      this.totalPage = 0});

  final String message;
  final List<UserCart> listOrdered;
  final int totalPage;
  final int currentPage;

  HistoryOrderState getListOrdered(
      {String message,
      List<UserCart> listOrdered,
      int totalPage,
      int currentPage}) {
    return HistoryOrderState(
        message: message ?? this.message,
        listOrdered: listOrdered ?? this.listOrdered,
        currentPage: currentPage ?? this.currentPage,
        totalPage: totalPage ?? this.totalPage);
  }

  @override
  List<Object> get props => [message, listOrdered];
}

// class InitialHistoryOrderState extends HistoryOrderState {
//   InitialHistoryOrderState()
//       : super(message: "", listOrdered: [], currentPage: 0, totalPage: 0);
// }

// class GetHistoryOrderState extends HistoryOrderState {
//   GetHistoryOrderState.addNewState(HistoryOrderState oldState,
//       {String message,
//       List<UserCart> listOrdered,
//       int totalPage,
//       int currentPage})
//       : super(
//             message: message ?? oldState.message,
//             listOrdered: listOrdered ?? oldState.listOrdered,
//             currentPage: currentPage ?? oldState.currentPage,
//             totalPage: totalPage ?? oldState.totalPage);
// }
