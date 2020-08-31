import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/res/util_functions.dart';

class ItemDish extends StatelessWidget {
  final int indexItem;

  const ItemDish({
    Key key,
    @required this.indexItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final dishItem = state.listCarts[indexItem].dishModel;
        return Dismissible(
          key: Key(dishItem.id),
          onDismissed: (direction) => context.bloc<CartBloc>().add(RemoveDishToCartEvent(dishItem)),
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
              onTap: () => UtilFunction.goToDishDetail(dishItem.id, context),
              contentPadding: EdgeInsets.all(10),
              title: Text(
                dishItem.name,
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              selected: false,
              subtitle: Text(
                "${dishItem.quantity.toString()} x ${dishItem.priceNew.toString()} = ${(dishItem.quantity * dishItem.priceNew)}",
                style: TextStyle(fontSize: 17),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => context.bloc<CartBloc>().add(UpdateDishToCartEvent(dishItem, dishItem.quantity - 1)),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => context.bloc<CartBloc>().add(UpdateDishToCartEvent(dishItem, dishItem.quantity + 1)),
                ),
              ]),
              dense: true,
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(dishItem.featureImage),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}
