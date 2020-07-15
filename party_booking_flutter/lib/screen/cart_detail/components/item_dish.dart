import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/res/util_functions.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemDish extends StatelessWidget {
  final int indexItem;

  const ItemDish({
    Key key,
    @required this.indexItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        final cartItem = model.cart[indexItem];
        return Dismissible(
          key: Key(cartItem.id),
          onDismissed: (direction) {
            model.removeProduct(cartItem);
          },
          direction: DismissDirection.endToStart,
          background: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.red,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete,
                  color: Colors.white,
              ),
            ),
          ),
          child: Card(
            color: Colors.white70,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              onTap: () => UtilFunction.goToDishDetail(cartItem.id, context),
              contentPadding: EdgeInsets.all(10),
              title: Text(
                cartItem.name,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              selected: false,
              subtitle: Text(
                "${cartItem.quantity.toString()} x ${cartItem.priceNew.toString()} = ${(cartItem.quantity * cartItem.priceNew)}",
                style: TextStyle(fontSize: 17),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    model.updateProduct(cartItem, cartItem.quantity - 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    model.updateProduct(cartItem, cartItem.quantity + 1);
                  },
                ),
              ]),
              dense: true,
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(cartItem.featureImage),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}
