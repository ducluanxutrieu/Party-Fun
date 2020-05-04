import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/get_user_profile_response_model.dart';

import 'history_order_detail_screen.dart';

class ListItem extends StatefulWidget {
  final UserCart userCart;
  ListItem(this.userCart);

  @override
  State<StatefulWidget> createState() {
    return ListItemState();
  }
}

class ListItemState extends State<ListItem> {
  List<String> listItems;
  bool isExpand = false;

  List<dynamic> getWeeks(UserCart userCart) {
    return [
      "Party Date" + " :  " + userCart.dateParty,
      "Num of Table" + " :  " + userCart.numberOfTable.toString(),
      "Total" + " :  " + userCart.totalMoney.toString(),
      "Status" + " :  " + userCart.paymentStatus.toString(),
      'More Detail'
    ].toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpand = false;
    listItems = getWeeks(widget.userCart);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (isExpand == true)
          ? const EdgeInsets.all(8.0)
          : const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: (isExpand != true)
                ? BorderRadius.all(Radius.circular(8))
                : BorderRadius.all(Radius.circular(22)),
            border: Border.all(color: Colors.green)),
        child: ExpansionTile(
          //   key: PageStorageKey<String>(this.widget.headerTitle),
          key: PageStorageKey<String>(listItems[0]),
          title: Container(
              width: double.infinity,
              child: Text(
                listItems[0],
                style: TextStyle(fontSize: (isExpand != true) ? 18 : 22),
              )),
          trailing: (isExpand == true)
              ? Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                  color: Colors.green,
                )
              : Icon(Icons.arrow_drop_up, size: 32, color: Colors.green),
          onExpansionChanged: (value) {
            setState(() {
              isExpand = value;
            });
          },
          children: [
            for (final item in listItems)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (item == "More Detail") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(userCart: widget.userCart),
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.green)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
              )
          ],
        ),
      ),
    );
  }
}
