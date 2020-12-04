import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/cart/cart_bloc.dart';
import 'package:party_booking/custom_extensions.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/dish/dish_bloc.dart';
import 'package:party_booking/widgets/common/logo_app.dart';

import '../../dish_detail/dish_detail_screen.dart';
import 'add_to_cart_dialog.dart';

class DishCard extends StatelessWidget {
  final DishModel dishModel;
  final AccountModel accountModel;

  const DishCard({Key key, this.dishModel, this.accountModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          child: InkWell(
            onTap: () => _goToDishDetail(context, dishModel),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    _cartDishPriceWidget(dishModel, context),
                    Spacer(),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.cartPlus),
                      onPressed: () {
                        context.read<CartBloc>().add(AddDishToCartEvent(dishModel));
                        AddToCartDialog.addDishToCartAnimation(context, state.totalItem);
                      }
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                _itemCardImage(dishModel.image[0], dishModel.id),
                SizedBox(
                  height: 5,
                ),
                Text(
                  dishModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _goToDishDetail(BuildContext context, DishModel dishModel) {
    BlocProvider.of<DishBloc>(context)
        .add(GetListRatesEvent(dishModel.id, true));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DishDetailScreen(
                dishModel: dishModel, accountModel: accountModel)));
  }

  Widget _cartDishPriceWidget(DishModel dishModel, BuildContext context) {
    String price = int.parse(dishModel.price?.toString()).toPrice();
    String priceNew = dishModel.priceNew?.toPrice();
    if (dishModel.discount != 0 || priceNew != null) {
      return Column(
        children: <Widget>[
          Text(
            price,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                decoration: TextDecoration.lineThrough
            ),
          ),
          Text(
            priceNew ?? '0',
            style: new TextStyle(
                fontSize: 20.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return Text(
      price,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget _itemCardImage(String image, String id) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        placeholder: (context, url) => LogoAppWidget(),
        imageUrl: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 150,
      ),
    );
  }
}
