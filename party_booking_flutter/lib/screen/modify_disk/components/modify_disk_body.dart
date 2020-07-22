import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/screen/modify_disk/components/form_modify_dish.dart';
import 'package:party_booking/screen/modify_disk/components/modify_dish_functions.dart';
import 'package:party_booking/screen/modify_disk/components/pick_image_button.dart';
import 'package:party_booking/widgets/common/app_button.dart';

import 'image_list.dart';

class ModifyDishBody extends StatefulWidget {
  final List<String> oldImages;
  final bool isAddNewDish;
  final DishModel dishModel;

  const ModifyDishBody({Key key, this.oldImages, this.isAddNewDish  = true, this.dishModel}) : super(key: key);

  @override
  _ModifyDishBodyState createState() => _ModifyDishBodyState();
}

class _ModifyDishBodyState extends State<ModifyDishBody> {
  List<File> newImages = List<File>();
  List<String> oldImages;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool isAddNewDish;

  @override
  void initState() {
    isAddNewDish = widget.isAddNewDish;
    oldImages = widget.oldImages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  PickImageButton(loadAssets: () => loadAssets(),),
                  SizedBox(
                    height: 10,
                  ),
                  ImageList( newImages: newImages, oldImages: oldImages, isOldImage: false),
                  SizedBox(
                    height: 10,
                  ),
                  ImageList( newImages: newImages, oldImages: oldImages, isOldImage: true),
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
                    buttonHandler: () => ModifyDishFunctions.addNewDishClicked(_fbKey, context, oldImages, newImages, isAddNewDish, widget.dishModel),
                    stateButton: 0,
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
    );
}

  Map<String, dynamic> _initValue() {
    if (isAddNewDish)
      return {'name': ""};
    else {
      print('*************Modify Dish********');
      print(widget.dishModel.id);
      return {
        'name': widget.dishModel.name ??= "",
        'description': widget.dishModel.description ??= "",
        'price': widget.dishModel.price.toString(),
        'type': widget.dishModel.categories,
        'discount': widget.dishModel.discount.toString()
      };
    }
  }

    Future<void> loadAssets() async {
    List<File> resultList;

    try {
      resultList = await FilePicker.getMultiFile(
        type: FileType.image
      );
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      newImages = resultList;
    });
  }
}