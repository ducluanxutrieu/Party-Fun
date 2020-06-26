import 'package:flutter/material.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/modify_disk/components/modify_dish_functions.dart';
import 'package:party_booking/screen/modify_disk/components/modify_disk_body.dart';

class ModifyDishScreen extends StatefulWidget {
  final DishModel dishModel;

  ModifyDishScreen({this.dishModel});

  @override
  _ModifyDishScreenState createState() => _ModifyDishScreenState();
}

class _ModifyDishScreenState extends State<ModifyDishScreen> {
  List<String> oldImages = List();
  bool isAddNewDish = false;

  @override
  void initState() {
    isAddNewDish = widget.dishModel == null || widget.dishModel.id == null;
    if (!isAddNewDish) {
      oldImages.addAll(widget.dishModel.image);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isAddNewDish ? Text('Add New Dish') : Text('Edit Dish'),
        actions: <Widget>[
          !isAddNewDish
              ? IconButton(
                  onPressed: () =>
                      ModifyDishFunctions.deleteDish(widget.dishModel.id).then(
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
        dishModel: widget.dishModel,
      ),
    );
  }
}
