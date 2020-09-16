import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/ui/history_order_list/bloc/history_order_repository.dart';

import '../history_order_detail/history_order_detail_screen.dart';
import 'bloc/history_order_bloc.dart';

class HistoryOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: RepositoryProvider(
        create: (context) => HistoryOrderRepository(),
        child: BlocProvider(
          create: (context) => HistoryOrderBloc(
              historyOrderRepository: new HistoryOrderRepository()),
          child: RefreshIndicator(
            onRefresh: () {
              context.bloc<HistoryOrderBloc>().add(GetListOrderEvent(true));
              Future.delayed(Duration(milliseconds: 300));
              return;
            },
            child: BlocBuilder<HistoryOrderBloc, HistoryOrderState>(
              buildWhen: (previous, current) =>
                  previous.listOrdered != current.listOrdered ||
                  previous.message != current.message,
              builder: (context, state) {
                int lengthList = state.listOrdered?.length ??= 0;
                return ListView.builder(
                  itemCount: ((lengthList == 0 ? -1 : lengthList) ?? -1  + 1),
                  itemBuilder: (context, index) {
                    return _locationItem(
                        index: index,
                        carts: state.listOrdered,
                        context: context,
                        currentPage: state.currentPage,
                        totalPage: state.totalPage);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCart(UserCart userCart, BuildContext context) {
    final currencyFormat =
        new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      color: userCart.paymentStatus == 1 ? Colors.greenAccent : Theme.of(context).colorScheme.surface,
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HistoryOrderDetailScreen(userCart: userCart),
            ),
          );
        },
        title: Text(
          "Time: ${DateFormat('dd-MM-yyyy HH:mm').format(userCart.dateParty)}",
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("\t" + currencyFormat.format(userCart.total),
            style: TextStyle(fontSize: 18)),
        trailing: userCart.paymentStatus == 1
            ? Icon(FontAwesomeIcons.solidCheckCircle)
            : SizedBox(),
      ),
    );
  }

  Widget _locationItem(
      {int index,
      List<UserCart> carts,
      int currentPage,
      int totalPage,
      BuildContext context}) {
    if (index == carts.length && totalPage != -1 && currentPage < totalPage) {
      return Container(
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              print(currentPage);
              context.bloc<HistoryOrderBloc>().add(GetListOrderEvent(false));
            },
            child: Icon(
              CustomIcons.ic_more,
              size: 35,
            )),
      );
    } else {
      if (index == carts.length && currentPage == totalPage) return SizedBox();
      return _buildItemCart(carts[index], context);
    }
  }
}
