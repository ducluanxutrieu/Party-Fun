import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:party_booking/screen/bookparty.dart';


class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  List<ListDishes> listDish = new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "Clear",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => ScopedModel.of<CartModel>(context).clearCart())
          ],
        ),
        body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                    .cart
                    .length ==
                0
            ? Center(
                child: Text("No items in Cart"),
              )
            : Container(
                padding: EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: ScopedModel.of<CartModel>(context,
                              rebuildOnChange: true)
                          .total,
                      itemBuilder: (context, index) {

                        return ScopedModelDescendant<CartModel>(
                          builder: (context, child, model) {
                            listDish.add(ListDishes(id: model.cart[index].id, numberDish: model.cart[index].qty.toString()));
                            return ListTile(
                              title: Text(model.cart[index].name),
                              subtitle: Text(model.cart[index].qty.toString() +
                                  " x " +
                                  model.cart[index].price.toString() +
                                  " = " +
                                  (model.cart[index].qty *
                                          model.cart[index].price)
                                      .toString()),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        listDish.clear();
                                        model.updateProduct(model.cart[index],
                                            model.cart[index].qty + 1);
                                        // model.removeProduct(model.cart[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        listDish.clear();
                                        model.updateProduct(model.cart[index],
                                            model.cart[index].qty - 1);
                                        // model.removeProduct(model.cart[index]);
                                      },
                                    ),
                                  ]),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Total: \$ " +
                            ScopedModel.of<CartModel>(context,
                                    rebuildOnChange: true)
                                .totalCartValue
                                .toString() +
                            "",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        elevation: 0,
                        child: Text("BUY NOW"),
                        onPressed: () {
                     //    requestBookParty();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>BookParty(listDish)));
                        },
                      ))
                ])));
  }

  Future<BaseResponseModel> requestBookParty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<ListDishes> listDish = new List();
    // listDish.add(ListDishes(id: ))
    var model = BookPartyRequestModel(
        dateParty: "Date party", numbertable: "3", lishDishs: listDish);
    var result = AppApiService.create().bookParty(
        token: prefs.getString(Constants.USER_TOKEN),
        model:  BookPartyRequestModel(
            dateParty: "10/10/1999", numbertable: "3", lishDishs: listDish),
    );

  }
}
