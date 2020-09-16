import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/ui/modify_disk/components/modify_dish_functions.dart';
import 'package:party_booking/ui/modify_disk/components/modify_disk_body.dart';

class ModifyDishScreen extends StatelessWidget {
  final DishModel dishModel;

  ModifyDishScreen({this.dishModel, @required this.isAddNewDish, this.oldImages});

  final List<String> oldImages;
  final bool isAddNewDish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isAddNewDish ? Text('Add New Dish') : Text('Edit Dish'),
        actions: <Widget>[
          !isAddNewDish
              ? IconButton(
                  onPressed: () =>
                      ModifyDishFunctions.deleteDish(dishModel.id).then(
                          (value) => {if (value) Navigator.pop(context, true)}),
                  icon: Icon(Icons.delete_forever),
                  tooltip: 'Delete this dish',
                )
              : SizedBox(),
        ],
      ),
      body: ModifyDishBody(
        isAddNewDish: isAddNewDish,
        oldImages: oldImages,
        dishModel: dishModel,
      ),
    );
  }
}
