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
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyDishFunctions{
  static BuildContext _context;
  static String _token;

  static void addNewDishClicked(GlobalKey<FormBuilderState> _fbKey, BuildContext context, List<String> oldImages, List<Asset> newImages, bool isAddNewDish, DishModel dishOrigin) async {
    String token = await _getToken();
    _context = context;
    if (_fbKey.currentState.saveAndValidate()) {
      String name = _fbKey.currentState.fields['name'].currentState.value;
      String price = _fbKey.currentState.fields['price'].currentState.value;
      String discount = _fbKey.currentState.fields['discount'].currentState.value;
      List<dynamic> categories =
          _fbKey.currentState.fields['type'].currentState.value;
      String description =
          _fbKey.currentState.fields['description'].currentState.value;

      List imageList = await _uploadImage(newImages);
      DishModel dishModel = DishModel(
          name: name,
          price: int.parse(price),
          description: description,
          categories: categories.cast<String>().toList(),
          discount: int.parse(discount),
          image: imageList,
          currency: 'VND');

      if (isAddNewDish) {
        _addNewDish(dishModel, token);
      } else {
        dishModel.id = dishOrigin.id;
        _updateDish(token, dishModel, oldImages);
      }
    }
  }

  static void _updateDish(String token, DishModel dishModel, List<String> oldImages) async {
    dishModel.image.addAll(oldImages);
    var result =
        await AppApiService.create().updateDish(token: token, model: dishModel);
    if (result.isSuccessful) {
      UTiu.showToast(message: result.body.message);
      Navigator.pop(_context, result.body.dish);
    }
  }

  static void _addNewDish(DishModel model, String token) async {
    DishRequestCreateModel dishModel = DishRequestCreateModel(
        name: model.name,
        currency: model.currency,
        image: model.image,
        discount: model.discount,
        categories: model.categories,
        description: model.description,
        price: model.price);
    if (model.image.isNotEmpty) {
      dishModel.featureImage = model.image[0];
    }

    Response<SingleDishResponseModel> addNewDishRes =
        await AppApiService.create().addNewDish(token: token, model: dishModel);
    if (addNewDishRes.isSuccessful) {
      UTiu.showToast(message: addNewDishRes.body.message);
      Navigator.pop(_context, true);
    }
  }

  static Future<List<String>> _uploadImage(List<Asset> newImages) async {
    if (newImages != null && newImages.isNotEmpty) {
      BaseListResponseModel uploadImageRes =
          await AppImageAPIService.create(_context).uploadImages(newImages);
      if (uploadImageRes != null) {
        List<String> imageList = uploadImageRes.data;
        return imageList;
      } else
        return List();
    } else
      return List();
  }

  static Future<bool> deleteDish(String dishId) async {
    await _getToken();
    var result = await AppApiService.create()
        .deleteDish(token: _token, id: dishId)
        .catchError((onError) {
      print(onError.toString());
    });
    if (result.isSuccessful) {
      UTiu.showToast(message: result.body.message);
      return true;
    }
    return false;
  }

  static Future<String> _getToken() async {
    if (_token == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _token = sharedPreferences.getString(Constants.USER_TOKEN);
      return _token;
    } else
      return _token;
  }
}