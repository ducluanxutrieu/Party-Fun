import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/dish/dish_bloc.dart';
import 'package:party_booking/res/custom_icons_icons.dart';
import 'package:party_booking/ui/modify_disk/modify_dish_screen.dart';
import 'package:party_booking/widgets/common/dialog_util.dart';

class FabDishDetail extends StatelessWidget {
  final AccountModel accountModel;
  final DishModel dishModel;

  const FabDishDetail({Key key, this.accountModel, this.dishModel})
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
        : BlocBuilder<DishBloc, DishState>(
            buildWhen: (previous, current) =>
                previous.rateDataModel != current.rateDataModel,
            builder: (context, state) => FloatingActionButton.extended(
              onPressed: () => _showRateDialog(
                  rateDataModel: state.rateDataModel, context: context),
              label: Text('Rating'),
              icon: Icon(CustomIcons.ic_rating),
              tooltip: 'Write your review!',
            ),
          );
  }

  _goToUpdateDish(BuildContext context) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModifyDishScreen(
                  dishModel: dishModel,
                  isAddNewDish: false,
                  oldImages: dishModel.image,
                )));
    if (result != null) {
      Navigator.maybePop(context, true);
    }
  }

  void _showRateDialog(
      {RateDataModel rateDataModel, BuildContext context}) async {
    String currentUsername = accountModel.username;
    String rateId = "";
    rateDataModel.listRate.forEach((rateItem) {
      if (rateItem.userRate == currentUsername) rateId = rateItem.id;
    });
    DialogUTiu.showDialogRating(context, dishModel.id, rateId).then((value) => {
          if (value)
            {
              BlocProvider.of<DishBloc>(context)
                  .add(GetListRatesEvent(dishModel.id, true))
            }
        });
  }
}
