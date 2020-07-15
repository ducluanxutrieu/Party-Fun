import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/widgets/common/dialog_util.dart';

class ItemRating extends StatelessWidget {
  final ListRate itemModel;

  const ItemRating({Key key, @required this.itemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            itemModel.avatar,
          ),
          backgroundColor: Colors.transparent,
        ),
        title: Row(
          children: <Widget>[
            Text(
              itemModel.userRate,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Spacer(),
            DialogUTiu.ratingBar(itemModel.score.toDouble(), 22, null)
          ],
        ),
        subtitle: Text(
          itemModel.comment,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}