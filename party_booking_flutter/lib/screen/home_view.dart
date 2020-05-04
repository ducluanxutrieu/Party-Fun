import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_user_profile_response_model.dart';

class HistoryOrder extends StatelessWidget {
  final UserCart userCart;
  HistoryOrder({@required this.userCart});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
          itemCount: userCart.listDishes.length,
          itemBuilder: (BuildContext context, int index) {
            return buildTripCard(userCart.listDishes[index]);
          }),
    );
  }

  Widget buildTripCard(ListDishes dishItem) {
    //    final trip = tripsList[index-2];
    return new Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.green)),
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  Text(
                    "Name" + "" + ":  " + dishItem.name.toString(),
                    style: new TextStyle(fontSize: 20.0,fontFamily: 'Source Sans Pro',),
                  ),
                  Spacer(),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Row(children: <Widget>[
                  Text(
                    "Quantity" + ":  " + dishItem.numberDish.toString(),
                    style: new TextStyle(fontSize: 20.0,fontFamily: 'Source Sans Pro',letterSpacing: 2.5,
                      fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
