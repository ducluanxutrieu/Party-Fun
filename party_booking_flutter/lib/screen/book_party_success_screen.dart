import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:url_launcher/url_launcher.dart';

class BookPartySuccessScreen extends StatefulWidget {
  final Bill mBill;

  BookPartySuccessScreen(this.mBill);

  @override
  _BookPartySuccessScreenState createState() => _BookPartySuccessScreenState();
}

class _BookPartySuccessScreenState extends State<BookPartySuccessScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_28owFDjd02mGhWN5XUDoq1S700UciXGH9F",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase order'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          label: Text(' Pay Now'),
          icon: Icon(FontAwesomeIcons.creditCard),
          onPressed: () {
            requestSource(widget.mBill);
          }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Customer: ${widget.mBill.username}',
                style: TextStyle(
                    fontFamily: 'Pacifico', color: Colors.orange, fontSize: 20),
              ),
            ),
            Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total bill'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '\$${widget.mBill.totalMoney}',
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
                                '${widget.mBill.numberTable}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ],
                          ),
                          Container(
                              width: 190,
                              height: 100,
                              child: Lottie.asset(Assets.animPayment)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Party time'),
                      Text(
                        '${widget.mBill.dateParty}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
              height: 300,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ListView.builder(
                  itemCount: widget.mBill.listDishes.length,
                  itemBuilder: (bCtx, index) {
                    var dish = widget.mBill.listDishes[index];
                    return Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: null,
                        contentPadding: EdgeInsets.all(10),
                        title: Text(
                          dish.name,
                          style: TextStyle(fontSize: 17, color: Colors.blue),
                        ),
                        selected: false,
                        trailing: Text(dish.numberDish.toString()),
                        dense: true,
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(dish.image),
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

  void getPayment(String id, String token, int totalMoney) async {
    await AppApiService.create().getPayment(token: token, id: id).then(
            (onValue) async {
              String urlSession = onValue.body.data.id;
              String url = "http://139.180.131.30/client/payment/mobile/$urlSession";
              if (await canLaunch(url)) {
              await launch(url);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
              } else {
              throw 'Could not launch $url';
              }
        }, onError: setError);
  }

  void requestSource(Bill mBill) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    getPayment(mBill.id, preferences.getString(Constants.USER_TOKEN), mBill.totalMoney);
  }
}
