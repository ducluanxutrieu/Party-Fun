import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/dish/dish_bloc.dart';
import 'package:party_booking/screen/modify_disk/components/form_modify_dish.dart';
import 'package:party_booking/screen/modify_disk/components/modify_dish_functions.dart';
import 'package:party_booking/screen/modify_disk/components/pick_image_button.dart';
import 'package:party_booking/src/dish_repository.dart';
import 'package:party_booking/widgets/common/app_button.dart';

import 'image_list.dart';

class ModifyDishBody extends StatelessWidget {
  final List<String> oldImages;
  final bool isAddNewDish;
  final DishModel dishModel;

  ModifyDishBody({Key key, this.oldImages, this.isAddNewDish  = true, this.dishModel}) : super(key: key);
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DishBloc(new DishRepository()),
      child: BlocBuilder<DishBloc, DishState>(
        buildWhen: (previous, current) => previous.listNewImage != current.listNewImage,
        builder: (context, state) => Center(
          child: FormBuilder(
            key: _fbKey,
            autovalidate: false,
            initialValue: _initValue(),
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FormModifyDish(),
                      PickImageButton(),
                      SizedBox(
                        height: 10,
                      ),
                      ImageList( newImages: state.listNewImage, oldImages: oldImages, isOldImage: false),
                      SizedBox(
                        height: 10,
                      ),
                      ImageList( newImages: state.listNewImage, oldImages: oldImages, isOldImage: true),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: AppButtonWidget(
                        buttonText: isAddNewDish ? 'Add New' : 'Update',
                        buttonHandler: () => ModifyDishFunctions.addNewDishClicked(_fbKey, context, oldImages, state.listNewImage, isAddNewDish, dishModel),
                        // stateButton: 0,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

  Map<String, dynamic> _initValue() {
    if (isAddNewDish)
      return {'name': ""};
    else {
      print('*************Modify Dish********');
      print(dishModel.id);
      return {
        'name': dishModel.name ??= "",
        'description': dishModel.description ??= "",
        'price': dishModel.price.toString(),
        'type': dishModel.categories,
        'discount': dishModel.discount.toString()
      };
    }
  }
}