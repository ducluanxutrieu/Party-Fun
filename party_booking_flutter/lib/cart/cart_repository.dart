import 'package:intl/intl.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/data/network/service/app_api_service.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CartRepository {
  Future<MapEntry<Bill, String>> requestBookParty(
      {DateTime day,
      int num,
      int cus,
      String discountCode,
      List<ListDishes> listDish}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    listDish.clear();
//    ScopedModel.of<CartModel>(context, rebuildOnChange: true).cart.forEach(
//            (item) =>
//        {listDish.add(ListDishes(id: item.id, numberDish: item.quantity))});

    var model = BookPartyRequestModel(
        dateParty: DateFormat(Constants.DATE_TIME_FORMAT_SERVER).format(day),
        numberTable: num,
        numberCustomer: cus,
        discountCode: discountCode,
        listDishes: listDish);

    print(model.toJson());
    var result = await AppApiService.create().bookParty(
      token: prefs.getString(Constants.USER_TOKEN),
      model: model,
    );
    if (result.isSuccessful) {
//      ScopedModel.of<CartModel>(context).clearCart();
//      UiUtiu.showToast(message: result.body.message);
//      Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(
//              builder: (context) => BookPartySuccessScreen(result.body.bill)));
      return MapEntry(result.body.bill, result.body.message);
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
//      UiUtiu.showToast(message: model.message, isFalse: true);
      return MapEntry(null, model.message);
    }
  }

  Future<String> getPayment(Bill bill) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constants.USER_TOKEN);

    var result = await AppApiService.create().getPayment(token: token, id: bill.id);

    if (result.isSuccessful) {
      String urlSession = result.body.data.id;
      String url = "https://partybooking.herokuapp.com/client/payment/mobile/$urlSession";
      if (await canLaunch(url)) {
        await launch(url);
        return "pay_success";
      } else {
        return 'Could not launch $url';
      }
    } else {
      BaseResponseModel model = BaseResponseModel.fromJson(result.error);
      return model.message;
    }
  }
}
