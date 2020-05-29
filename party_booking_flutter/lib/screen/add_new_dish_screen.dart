import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:party_booking/data/network/model/base_list_response_model.dart';
import 'package:party_booking/data/network/model/list_dish_category_response_model.dart';
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

  AddNewDishScreen({this.dishModel});

  @override
  _AddNewDishScreenState createState() => _AddNewDishScreenState();
}

class _AddNewDishScreenState extends State<AddNewDishScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<Asset> images = List<Asset>();
  String _token;
  bool isAddNewDish = false;

  @override
  void initState() {
    isAddNewDish = widget.dishModel == null || widget.dishModel.id == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        isAddNewDish ? Text('Add New Dish') : Text('Edit Dish'),
        actions: <Widget>[
          !isAddNewDish ? IconButton(
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
                    _buildNewImageGridView(),
                    !isAddNewDish
                        ? _buildOldImageGridView()
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
                          isAddNewDish ? 'Add New' : 'Update',
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
      String categories = _fbKey.currentState.fields['type'].currentState.value;
      String description =
          _fbKey.currentState.fields['description'].currentState.value;
      if (isAddNewDish) {
        _addNewDish(name, price, description, categories);
      } else {
        String token = await _getToken();
        Map<String, dynamic> formData = {
          '_id': widget.dishModel.id,
          'name': name,
          'description': description,
          'categories': ListDishCategoryResponseModel().getListIdCategory(categories),
          'discount': '0',
          'price': price,
          'currency': 'vnd',
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

  void _addNewDish(String name, String price, String description, String category) async {
    BaseListResponseModel uploadImageRes = await AppImageAPIService.create(context)
        .uploadImages(images);

    if (uploadImageRes != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(Constants.USER_TOKEN);
      List<String> categories = List();
      categories.add(category);
      List imageList = uploadImageRes.data;
      DishModel dishModel = DishModel(name: name, price: int.parse(price), description: description, categories: categories, discount: 10, image: imageList, featureImage: imageList[0], currency: 'VND');
      Response<SingleDishResponseModel> addNewDishRes = await AppApiService.create().addNewDish(token: token, model: dishModel);
      if(addNewDishRes.isSuccessful){
        UTiu.showToast(addNewDishRes.body.message);
        Navigator.pop(context, uploadImageRes);
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
    return isAddNewDish
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

  Widget _buildNewImageGridView() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 500,
          minHeight: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: images.isNotEmpty ? GridView.count(
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
      )
    : SizedBox()
    );
  }

  Widget _buildOldImageGridView() {
    List imageList = widget.dishModel.image;
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 500,
          minHeight: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: imageList.isNotEmpty ? GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: List.generate(imageList.length, (index) {
            return Container(width: 300, height: 300, child: Image.network(imageList[index]));
          }),
        )
            : SizedBox()
    );
  }

  Map<String, dynamic> _initValue() {
    if (isAddNewDish)
      return {'name': ""};
    else {
      return {
        'name': widget.dishModel.name ?? "",
        'description': widget.dishModel.description ?? "",
        'price': widget.dishModel.price.toString() ?? "",
        'type': widget.dishModel.categories
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
