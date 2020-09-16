import 'dart:async';

import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HistoryOrderStatus {
  empty,
  loadMored,
  full,
}

class HistoryOrderRepository {
  int currentPage = 0;
  int totalPage = -1;
  List<UserCart> listUserCart = List<UserCart>();

  final _controller = StreamController<HistoryOrderStatus>();

  Stream<HistoryOrderStatus> get status async* {
    yield HistoryOrderStatus.empty;
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  Future<MapEntry<List<UserCart>, String>> getHistoryBooking(
      {bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 0;
      listUserCart.clear();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.USER_TOKEN);
    currentPage++;
    var result = await AppApiService.create()
        .getUserHistory(token: token, page: currentPage);
    if (result.isSuccessful) {
      totalPage = result.body.data.totalPage;
      listUserCart.addAll(result.body.data.userCarts);
      print(listUserCart.length);

      _controller.add(HistoryOrderStatus.loadMored);
      if (currentPage == totalPage) {
        _controller.add(HistoryOrderStatus.full);
      }
      return MapEntry(listUserCart, result.body.message);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      return MapEntry(null, model.message);
    }
  }
}
