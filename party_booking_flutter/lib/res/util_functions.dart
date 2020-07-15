import 'package:flutter/material.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/dish_detail/dish_detail_screen.dart';

class UtilFunction{
  static void goToDishDetail(String dishId, BuildContext context) async {
    DishModel dishModel = await DBProvider.db.getDish(dishId);
    print(dishId);
    print(dishModel);
    if (dishModel != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DishDetailScreen(dishModel: dishModel)));
    }
  }
}