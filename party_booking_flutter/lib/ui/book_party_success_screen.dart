import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/util_functions.dart';

class BookPartySuccessScreen extends StatelessWidget {
  final Bill mBill;
  BookPartySuccessScreen(this.mBill);

  @override
  Widget build(BuildContext context) {
    var timeFormatter = DateFormat('dd-MM-yyyy HH:mm');
    double sizeWidth = MediaQuery.of(context).size.width - 33;
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.messagePayment != current.messagePayment,
      listener: (context, state) {
        print(state.messagePayment);
        print('book_party_success_screen');
        print("___________");
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.messagePayment)));
        if (state.message == "pay_success") {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Purchase Order'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            label: Text(' Pay Now'),
            icon: Icon(FontAwesomeIcons.creditCard),
            onPressed: () {
              // requestSource(widget.mBill);
              context.bloc<CartBloc>().add(GetPaymentEvent(mBill));
            }),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Customer: ${mBill.customer}',
                style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    color: Colors.orange,
                    fontSize: 20),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: sizeWidth * 0.55,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total bill'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$${mBill.total}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Number of Tables'),
                              Text(
                                '${mBill.table}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: sizeWidth * 0.45,
                            child: Lottie.asset(Assets.animPayment,
                                fit: BoxFit.contain)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Party time'),
                    Text(
                      '${timeFormatter.format(mBill.dateParty)}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'List dishes',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 20),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                  itemCount: mBill.dishes.length,
                  itemBuilder: (bCtx, index) {
                    var dish = mBill.dishes[index];
                    return ItemDishLine(dish: dish);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDishLine extends StatelessWidget {
  const ItemDishLine({
    Key key,
    @required this.dish,
  }) : super(key: key);

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () => UtilFunction.goToDishDetail(dish.id, context),
        contentPadding: EdgeInsets.all(10),
        title: Text(
          dish.name,
          style: TextStyle(fontSize: 17, color: Colors.blue),
        ),
        subtitle: Text(
          dish.price.toString(),
          style: kPrimaryTextStyle.copyWith(fontSize: 15),
        ),
        selected: false,
        trailing: Text(dish.count.toString()),
        dense: true,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(dish.featureImage ??=
              'https://pbs.twimg.com/profile_images/1093186805283749890/4yb0033d_400x400.jpg'),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
