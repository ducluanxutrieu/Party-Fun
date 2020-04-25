import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/get_payment_request_mode.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

class BookPartySuccessScreen extends StatefulWidget {
  final Bill mBill;

  BookPartySuccessScreen(this.mBill);

  @override
  _BookPartySuccessScreenState createState() => _BookPartySuccessScreenState();
}

class _BookPartySuccessScreenState extends State<BookPartySuccessScreen> {
  Token _paymentToken;
  PaymentMethod _paymentMethod;

//  PaymentIntentResult _paymentIntent;
//  CreditCard testCard;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var cardInfo = CardFormPaymentRequest(
      prefilledInformation: PrefilledInformation(
          billingAddress: BillingAddress(
              name: 'PartyBooking',
              city: 'HCM',
              country: 'VietNam',
              line1: 'KTX Khu A',
              postalCode: '70000')),
      requiredBillingAddressFields: 'KTX Khu A');

  @override
  initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_JAMtZa7BVlk7wXRM3aUtsg3H00rFK1TwPR",
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
/*            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyApp()) */
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

  void getPayment(String id, String token, int totalMoney, AccountModel accountModel) async{
    var model = GetPaymentRequestModel(id: id);
    await AppApiService.create().getPayment(mode: model, token: token).then((onValue){
      StripePayment.createSourceWithParams(SourceParams(
        type: 'ideal',
        amount: totalMoney,
        country: 'vn',
        email: accountModel.email,
        name: accountModel.fullName,
        currency: 'VND',
        returnURL: onValue.body.data.successUrl,
      )).then((source) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
      }).catchError(setError);
    }, onError: setError);
  }

  void requestSource(Bill mBill) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String accountJson = preferences.getString(Constants.ACCOUNT_MODEL_KEY);
    AccountModel accountModel = AccountModel.fromJson(json.decode(accountJson));
    getPayment(mBill.id, preferences.getString(Constants.USER_TOKEN), mBill.totalMoney, accountModel);
  }
}

//  void requestPaymentNative() async{
//    bool isSupportNativePay = await StripePayment.deviceSupportsNativePay();
//    if(isSupportNativePay){
//      StripePayment.paymentRequestWithNativePay(
//        androidPayOptions: AndroidPayPaymentRequest(
//          total_price: widget.mBill.totalMoney.toString(),
//          currency_code: "VND",
//        ),
//        applePayOptions: ApplePayPaymentOptions(
//          countryCode: 'VN',
//          currencyCode: 'VND',
//          items: [
//            ApplePayItem(
//              label: 'Test',
//              amount: widget.mBill.totalMoney.toString(),
//            )
//          ],
//        ),
//      ).then((token) {
//        setState(() {
//          _paymentToken = token;
//        });
//      }).catchError((setError) => {);
//    }else{
//
//    }
//  }

//  void createPaymentWithCard() {
//    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
//        .then((paymentMethod) {
//      StripePayment.createTokenWithCard(
//        paymentMethod.card,
//      ).then((token) {
//        setState(() {
//          _paymentToken = token;
//        });
//      }).catchError(setError);
//      _scaffoldKey.currentState.showSnackBar(
//          SnackBar(content: Text('Received ${paymentMethod.id}')));
//      setState(() {
//        _paymentMethod = paymentMethod;
//      });
//    }).catchError(setError);
//  }
