import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';

class BookPartySuccessScreen extends StatefulWidget {
  final Bill mBill;
  BookPartySuccessScreen(this.mBill);

  @override
  _BookPartySuccessScreenState createState() => _BookPartySuccessScreenState();
}

class _BookPartySuccessScreenState extends State<BookPartySuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase order'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            child: ListView.builder(
                itemCount: widget.mBill.listDishes.length,
                itemBuilder: (bCtx, index) {
                  var dish = widget.mBill.listDishes[index];
                  return ListTile(
                    title: Text(dish.name),
                    onTap: null,
                  );
                }),
          )
        ],
      ),
    );
  }
}
