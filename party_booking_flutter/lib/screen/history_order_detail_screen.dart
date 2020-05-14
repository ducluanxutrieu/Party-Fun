import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/res/assets.dart';

class HistoryOrderDetailScreen extends StatelessWidget {
  final UserCart userCart;
  HistoryOrderDetailScreen({@required this.userCart});

  @override
  Widget build(BuildContext context) {
    var dish = userCart.dishes;
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt Detail"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Customer: ${userCart.customer}',
                style: TextStyle(
                    fontFamily: 'Pacifico', color: Colors.orange, fontSize: 20),
              ),
            ),
            _buildHeader(),
            Container(
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
            Container(
              height: 500,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: new ListView.builder(
                  itemCount: dish.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currencyFormat =
                    new NumberFormat.currency(locale: "vi_VI", symbol: "₫");
                    return Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: null,
                        contentPadding: EdgeInsets.all(10),
                        title: Text(
                          dish[index].name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(currencyFormat.format(dish[index].price),
                            style:
                            TextStyle(fontSize: 17, color: Colors.lightBlueAccent)),
                        selected: false,
                        trailing: Text(
                          dish[index].count.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        dense: true,
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(dish[index].featureImage),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
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
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Number of Tables'),
                  Text(
                    '${userCart.table}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Number of Customers'),
                  Text(
                    '${userCart.countCustomer}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Party time'),
                  Text(
                    '${DateFormat('dd-MM-yyyy HH:mm').format(userCart.dateParty)}',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
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
    );
  }
}
