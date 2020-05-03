import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewDishScreen extends StatefulWidget {
  final DishModel dishModel;

  AddNewDishScreen(this.dishModel);

  @override
  _AddNewDishScreenState createState() => _AddNewDishScreenState();
}

class _AddNewDishScreenState extends State<AddNewDishScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<Asset> images = List<Asset>();
  String _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.dishModel == null ? Text('Add New Dish') : Text('Edit Dish'),
        actions: <Widget>[
          widget.dishModel != null ? IconButton(
            onPressed: _deleteDish,
            icon: Icon(Icons.delete_forever),
            tooltip: 'Delete this dish',
          ) : SizedBox(),
        ],
      ),
      body: Center(
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
                    _buildForm(),
                    _pickImageButton(),
                    SizedBox(
                      height: 10,
                    ),
                    widget.dishModel == null
                        ? ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 500,
                              minHeight: 0,
                              maxWidth: MediaQuery.of(context).size.width,
                            ),
                            child: _buildGridView())
                        : SizedBox(),
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
                      buttonText:
                          widget.dishModel == null ? 'Add New' : 'Update',
                      buttonHandler: () => _addNewDishClicked(context),
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
      ),
    );
  }

  void _addNewDishClicked(BuildContext context) async {
    if (_fbKey.currentState.saveAndValidate()) {
      String name = _fbKey.currentState.fields['name'].currentState.value;
      String price = _fbKey.currentState.fields['price'].currentState.value;
      String type = _fbKey.currentState.fields['type'].currentState.value;
      String description =
          _fbKey.currentState.fields['description'].currentState.value;
      if (widget.dishModel == null) {
        BaseResponseModel result = await AppImageAPIService.create(context)
            .addNewDish(images, name, description, type, price);
        if (result != null) {
          UTiu.showToast(result.message);
          Navigator.pop(context, result);
        }
      } else {
        String token = await _getToken();
        Map<String, dynamic> formData = {
          '_id': widget.dishModel.id,
          'name': name,
          'description': description,
          'type': type,
          'discount': '0',
          'price': price,
        };
        var result = await AppApiService.create()
            .updateDish(token: token, data: formData);
        if (result.isSuccessful) {
          UTiu.showToast(result.body.message);
          Navigator.pop(context, result.body.dish);
        }
      }
    }
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
//      error = e.toString();
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  Widget _pickImageButton() {
    return widget.dishModel == null
        ? Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.lightGreen,
            child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                onPressed: loadAssets,
                child: Text(
                  'Pick Dish Image',
                  textAlign: TextAlign.center,
                  style: mStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          )
        : SizedBox();
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        TextFieldWidget(
          mAttribute: 'name',
          mHindText: 'Dish name',
          mValidators: [FormBuilderValidators.required()],
        ),
        SizedBox(
          height: 15,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300,
            maxWidth: double.infinity,
          ),
          child: FormBuilderTextField(
              attribute: 'description',
              style: mStyle,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32))),
              validators: [FormBuilderValidators.required()]),
        ),
        SizedBox(
          height: 15,
        ),
        _selectDishType(),
        SizedBox(
          height: 15,
        ),
        TextFieldWidget(
          mAttribute: 'price',
          mHindText: 'Price',
          mValidators: [FormBuilderValidators.required()],
          mTextInputType: TextInputType.number,
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _selectDishType() {
    return FormBuilderDropdown(
      attribute: "type",
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
          labelText: "Dish Type",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      // initialValue: 'Male',
      hint: Text('Select Dish Type', style: mStyle),
      validators: [FormBuilderValidators.required()],

      items: [
        'Holiday Offers',
        'First Dishes',
        'Main Dishes',
        'Seafood',
        'Drinks',
        'Dessert'
      ]
          .map((gender) =>
              DropdownMenuItem(value: gender, child: Text("$gender")))
          .toList(),
    );
  }

  Widget _buildGridView() {
    if (images.isNotEmpty)
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return null;
  }

  Map<String, dynamic> _initValue() {
    if (widget.dishModel == null)
      return {'name': ""};
    else {
      return {
        'name': widget.dishModel.name ?? "",
        'description': widget.dishModel.description ?? "",
        'price': widget.dishModel.price.toString() ?? "",
        'type': widget.dishModel.type
      };
    }
  }

  void _deleteDish() async {
    await _getToken();
    var result = await AppApiService.create()
        .deleteDish(token: _token, id: widget.dishModel.id)
        .catchError((onError) {
      print(onError.toString());
    });
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      Navigator.pop(context, widget.dishModel);
    }
  }

  Future<String> _getToken() async {
    if (_token == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _token = sharedPreferences.getString(Constants.USER_TOKEN);
      return _token;
    } else
      return _token;
  }
}
