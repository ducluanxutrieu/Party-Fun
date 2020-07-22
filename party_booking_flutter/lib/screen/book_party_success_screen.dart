import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/res/util_functions.dart';
import 'package:party_booking/screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BookPartySuccessScreen extends StatefulWidget {
  final Bill mBill;

  BookPartySuccessScreen(this.mBill);

  @override
  _BookPartySuccessScreenState createState() => _BookPartySuccessScreenState();
}

class _BookPartySuccessScreenState extends State<BookPartySuccessScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  Widget build(BuildContext context) {
    var timeFormatter = DateFormat('dd-MM-yyyy HH:mm');
    double sizeWidth = MediaQuery.of(context).size.width - 33;
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Order'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          label: Text(' Pay Now'),
          icon: Icon(FontAwesomeIcons.creditCard),
          onPressed: () {
            requestSource(widget.mBill);
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'Customer: ${widget.mBill.customer}',
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
                              '\$${widget.mBill.total}',
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
                              '${widget.mBill.table}',
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
                    '${timeFormatter.format(widget.mBill.dateParty)}',
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
                itemCount: widget.mBill.dishes.length,
                itemBuilder: (bCtx, index) {
                  var dish = widget.mBill.dishes[index];
                  return ItemDishLine(dish: dish);
                }),
          ),
        ],
      ),
    );
  }

  void getPayment(String id, String token, int totalMoney) async {
    await AppApiService.create().getPayment(token: token, id: id).then(
        (onValue) async {
      String urlSession = onValue.body.data.id;
      String url = "http://139.180.131.30/client/payment/mobile/$urlSession";
      if (await canLaunch(url)) {
        await launch(url);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false);
      } else {
        throw 'Could not launch $url';
      }
    }, onError: setError);
  }

  void requestSource(Bill mBill) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    getPayment(
        mBill.id, preferences.getString(Constants.USER_TOKEN), mBill.total);
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
