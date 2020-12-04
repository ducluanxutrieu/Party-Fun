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
        final dishItem = state.carts[indexItem];
        return Dismissible(
          key: Key(dishItem.id),
          onDismissed: (direction) => context.read<CartBloc>().add(RemoveDishToCartEvent(dishItem)),
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
            color: Theme.of(context).colorScheme.surface,
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
                  onPressed: () => context.read<CartBloc>().add(UpdateDishToCartEvent(dishItem, false)),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => context.read<CartBloc>().add(UpdateDishToCartEvent(dishItem, true)),
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
