import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/service/app_image_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/app_button.dart';
import 'package:party_booking/widgets/common/text_field.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewDishScreen extends StatefulWidget {
  @override
  _AddNewDishScreenState createState() => _AddNewDishScreenState();
}

class _AddNewDishScreenState extends State<AddNewDishScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Dish'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: FormBuilder(
            key: _fbKey,
            autovalidate: false,
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
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 500,
                            maxWidth: double.infinity,
                          ),
                          child: buildGridView()),
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
                        buttonText: 'Add New',
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
//      BaseResponseModel baseResponseModel= await addNewDish(name, description, type, price);
      BaseResponseModel result = await AppImageAPIService.create(context)
          .addNewDish(images, name, description, type, price);
      if (result != null) {
        UTiu.showToast(result.message);
        Navigator.pop(context, result);
      }
    }
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
//      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
//      if (error == null) _error = 'No Error Dectected';
    });
  }

  Future<BaseResponseModel> addNewDish(
      String name, String description, String type, String price) async {
    // string to uri
    Uri uri = Uri.parse('http://139.180.131.30:3000/product/adddish');

// create multipart request
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MultipartRequest request = http.MultipartRequest("POST", uri);
    request.headers['authorization'] = prefs.getString(Constants.USER_TOKEN);

    images
        .map((item) => () async {
              ByteData byteData = await item.getByteData();
              List<int> imageData = byteData.buffer.asUint8List();

              MultipartFile multipartFile = MultipartFile.fromBytes(
                'image',
                imageData,
                filename: 'dish_images.jpg',
                contentType: MediaType("image", "jpg"),
              );

// add file to multipart
              request.files.add(multipartFile);
            })
        .toList();
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['type'] = type;
    request.fields['discount'] = '0';
// send
    var response = await request.send();
    print('*************************');
    print(response.statusCode);
    return baseResponseModelFromJson(response.toString());
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

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        shrinkWrap: false,
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
      return Container(color: Colors.white);
  }
}
