import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:party_booking/data/network/model/base_list_response_model.dart';
import 'package:party_booking/data/network/model/dish_create_request_model.dart';
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
  List<Asset> newImages = List<Asset>();
  List<String> oldImages;
  String _token;
  bool isAddNewDish = false;

  @override
  void initState() {
    isAddNewDish = widget.dishModel == null || widget.dishModel.id == null;
    oldImages = widget.dishModel.image;
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
                  onPressed: _deleteDish,
                  icon: Icon(Icons.delete_forever),
                  tooltip: 'Delete this dish',
                )
              : SizedBox(),
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
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: !isAddNewDish,
                        child: _buildOldImageGridView()),
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
    String token = await _getToken();
    if (_fbKey.currentState.saveAndValidate()) {
      String name = _fbKey.currentState.fields['name'].currentState.value;
      String price = _fbKey.currentState.fields['price'].currentState.value;
      List<String> categories =
          _fbKey.currentState.fields['type'].currentState.value;
      String description =
          _fbKey.currentState.fields['description'].currentState.value;

      List imageList = await _uploadImage();
      DishModel dishModel = DishModel(
          id: widget.dishModel.id,
          name: name,
          price: int.parse(price),
          description: description,
          categories: categories,
          discount: 10,
          image: imageList,
          featureImage: imageList[0],
          currency: 'VND');

      if (isAddNewDish) {
        _addNewDish(dishModel, token);
      } else {
        _updateDish(token, dishModel);
      }
    }
  }

  void _updateDish(String token, DishModel dishModel) async {
    dishModel.image.addAll(oldImages);
    var result =
        await AppApiService.create().updateDish(token: token, model: dishModel);
    if (result.isSuccessful) {
      UTiu.showToast(result.body.message);
      Navigator.pop(context, result.body.dish);
    }
  }

  void _addNewDish(DishModel model, String token) async {
    DishRequestCreateModel dishModel = DishRequestCreateModel(
        name: model.name,
        currency: model.currency,
        featureImage: model.featureImage,
        image: model.image,
        discount: model.discount,
        categories: model.categories,
        description: model.description,
        price: model.price);

    Response<SingleDishResponseModel> addNewDishRes =
        await AppApiService.create().addNewDish(token: token, model: dishModel);
    if (addNewDishRes.isSuccessful) {
      UTiu.showToast(addNewDishRes.body.message);
      Navigator.pop(context, true);
    }
  }

  Future<List<String>> _uploadImage() async {
    BaseListResponseModel uploadImageRes =
        await AppImageAPIService.create(context).uploadImages(newImages);
    if (uploadImageRes != null) {
      List<String> imageList = uploadImageRes.data;
      return imageList;
    } else
      return List();
  }

  Future<void> loadAssets() async {
    setState(() {
      newImages = List<Asset>();
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
      newImages = resultList;
    });
  }

  Widget _pickImageButton() {
    return Material(
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
    );
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
    return FormBuilderCheckboxList(
      attribute: "type",
      decoration: InputDecoration(
          labelText: "Dish Type",
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      validators: [FormBuilderValidators.required()],
      options: [
        FormBuilderFieldOption(value: "Holiday Offers"),
        FormBuilderFieldOption(value: "First Dishes"),
        FormBuilderFieldOption(value: "Main Dishes"),
        FormBuilderFieldOption(value: "Seafood"),
        FormBuilderFieldOption(value: "Drinks"),
        FormBuilderFieldOption(value: "Dessert"),
      ],
    );
  }

  Widget _buildNewImageGridView() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 500,
          minHeight: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: newImages.isNotEmpty
            ? GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: List.generate(newImages.length, (index) {
                  Asset asset = newImages[index];
                  return Container(
                      width: 300,
                      height: 300,
                      child: Stack(children: <Widget>[
                        AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  newImages.removeAt(index);
                                });
                              },
                            )
                          ],
                        ),
                      ]));
                }),
              )
            : SizedBox());
  }

  Widget _buildOldImageGridView() {
    return Column(
      children: <Widget>[
        Divider(
          height: 10,
          color: Colors.green,
        ),
        Text(
          'Old Image',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 500,
              minHeight: 0,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: oldImages.isNotEmpty
                ? GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: List.generate(oldImages.length, (index) {
                      return Container(
                          width: 300,
                          height: 300,
                          child: Stack(children: <Widget>[
                            Image.network(oldImages[index]),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      oldImages.removeAt(index);
                                    });
                                  },
                                )
                              ],
                            ),
                          ]));
                    }),
                  )
                : SizedBox()),
      ],
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
      Navigator.pop(context, true);
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
