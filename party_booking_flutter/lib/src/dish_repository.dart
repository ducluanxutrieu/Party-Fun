import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:party_booking/data/database/db_provide.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:party_booking/widgets/common/utiu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DishRepository {
  int currentPage = 0;
  RateDataModel rateDataModel = RateDataModel();

  Future<List<DishModel>> getListDishes({String where = ""}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(Constants.USER_TOKEN);

    var result = await AppApiService.create().getListDishes(token: _token);
    if (result == null || !result.isSuccessful)
      return await getListDishesFromDB();
    else
      _saveListDishesToDB(result.body.listDishes);

    return result.body.listDishes;
  }

  Future<List<Category>> getListCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = await AppApiService.create().getCategories();
    if (result != null && result.isSuccessful) {
      prefs.setString(Constants.LIST_CATEGORIES_KEY,
          listCategoriesResponseModelToJson(result.body));
      return result.body.categories;
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      UiUtiu.showToast(message: model.message, isFalse: true);
      return await getListCategoriesFromDB();
    }
  }

  Future<List<DishModel>> searchListDish(String searchText) async {
    List<DishModel> listDishes =
        await DBProvider.db.searchAllDishes(searchText);
    return listDishes;
  }

  Future<List<Category>> getListCategoriesFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String categoriesJson = prefs.getString(Constants.LIST_CATEGORIES_KEY);
    if (categoriesJson != null || categoriesJson.isNotEmpty) {
      ListCategoriesResponseModel categories =
          listCategoriesResponseModelFromJson(categoriesJson);
      return categories.categories;
    } else
      return List();
  }

  Future<List<DishModel>> getListDishesFromDB() async {
    List<DishModel> listDishes = await DBProvider.db.getAllDishes();
    return listDishes;
  }

  Future<void> _saveListDishesToDB(List<DishModel> listDishes) async {
    await DBProvider.db.deleteAll();
    listDishes.forEach((element) async {
      await DBProvider.db.newDish(element);
      print(element);
    });
  }

  Future<MapEntry<List<File>, String>> loadAssets() async {
    FilePickerResult resultList;
    List<File> files = new List();

    try {
      resultList = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);
      if(resultList != null) {
        files = resultList.paths.map((path) => File(path)).toList();
      } else {
        Fluttertoast.showToast(msg: "Cancelled", toastLength: Toast.LENGTH_SHORT);
      }
    } on Exception catch (e) {
      print(e.toString());
      return MapEntry(null, e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
    return MapEntry(files, "");
  }

  Future<MapEntry<String, bool>> getListRate(String id, {bool isStart = false}) async {
    if(isStart) currentPage = 0;
    currentPage++;
    var result = await AppApiService.create().getRate(id, currentPage);
    if (result.isSuccessful) {
      if (currentPage == 1) {
        rateDataModel = result.body.rateData;
      } else {
        rateDataModel.listRate.addAll(result.body.rateData.listRate);
        rateDataModel.end = result.body.rateData.end;
      }
      return MapEntry(result.body.message, true);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      return MapEntry(model.message, false);
    }
  }
}
