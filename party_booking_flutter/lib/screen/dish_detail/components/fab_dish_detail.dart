import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/res/custom_icons.dart';
import 'package:party_booking/screen/modify_disk/modify_dish_screen.dart';

class FabDishDetail extends StatelessWidget {
  final AccountModel accountModel;
  final DishModel dishModel;
  final Function showRateDialog;

  const FabDishDetail(
      {Key key, this.accountModel, this.dishModel, this.showRateDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isStaff = accountModel != null &&
        (accountModel.role == UserRole.Staff.index ||
            accountModel.role == UserRole.Admin.index);

    return isStaff
        ? FloatingActionButton.extended(
            onPressed: () => _goToUpdateDish(context),
            label: Text('Edit'),
            icon: Icon(FontAwesomeIcons.edit),
            tooltip: 'Edit this dish',
          )
        : FloatingActionButton.extended(
            onPressed: () => showRateDialog(),
            label: Text('Rating'),
            icon: Icon(CustomIcons.ic_rating),
            tooltip: 'Write your review!',
          );
  }

  _goToUpdateDish(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModifyDishScreen(dishModel: dishModel)));
    if (result != null) {
      Navigator.maybePop(context, true);
    }
  }
}
