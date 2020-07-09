import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/res/assets.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    Key key,
    @required this.userCart,
  }) : super(key: key);

  final UserCart userCart;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black87);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
        ),
        child: Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Total bill'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '\$${userCart.total}',
                      style: textStyle,
                    ),
                    SizedBox(height: 10,),
                    RichText(
                      text: TextSpan(
                        children: [
                        TextSpan(text: "Payment: ", style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: userCart.paymentStatus == 1 ? 'Yes' : 'No', style: textStyle.copyWith(fontSize: 18))
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Number of Tables'),
                    Text(
                      '${userCart.table}',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Number of Customers'),
                    Text(
                      '${userCart.countCustomer}',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Party time'),
                    Text(
                      '${DateFormat('dd-MM-yyyy HH:mm').format(userCart.dateParty)}',
                      style: textStyle.copyWith(fontSize: 17),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                    width: 190,
                    height: 190,
                    child: Lottie.asset(Assets.animBillManagement)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}