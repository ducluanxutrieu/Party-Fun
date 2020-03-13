import 'dart:io';
import 'dart:math';

import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/res/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:party_booking/file_extention.dart';

class AppImageAPIService {
  static String token;
  final Dio dio;

  AppImageAPIService({this.dio});

  Future<BaseResponseModel> updateAvatar(File imageToUpdate) async {
    FormData formData = new FormData.from({
      "image": new UploadFileInfo(imageToUpdate, imageToUpdate.name, contentType: ContentType('image', 'jpeg')),
//    "image": MultipartFile.fromFile(imageToUpdate.path, filename: imageToUpdate.name, contentType: ContentType('image', 'jpeg'))
    });

    BaseResponseModel response;
    var result = await dio.post('user/uploadavatar', data: formData,
        onSendProgress: (int sent, int total) {
      print("Luan sent");
      print("$sent $total");
    }, onReceiveProgress: (int receive, int total) {
      print("Luan receive");
      print("$receive $total");
    });

    if (result.statusCode == 200) {
      response = BaseResponseModel.fromJson(result.data);
    }
    return response;
  }

  static AppImageAPIService create() {
    var random = Random();
    String boundary = '--dio-boundary-' +
        random.nextInt(4294967296).toString().padLeft(10, '0');
    BaseOptions options = new BaseOptions(
        baseUrl: "http://139.180.131.30:3000/",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        method: 'POST');
    Dio dio = new Dio(options);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      // If no token, request token firstly and lock this interceptor
      // to prevent other request enter this interceptor.

      if (token == null) {
        dio.interceptors.requestLock.lock();
        // We use a new Dio(to avoid dead lock) instance to request token.
        SharedPreferences preferences = await SharedPreferences.getInstance();
        AccountModel accountModel = accountModelFromJson(
            preferences.getString(Constants.ACCOUNT_MODEL_KEY));
        token = accountModel.token;
      }
      //Set the token to headers
      options.headers["authorization"] = token;
      options.headers['content-type'] = "multipart/form-data; boundary=${boundary.substring(2)}";
      dio.interceptors.requestLock.unlock();
      return options; //continue
    }));
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true));
    return AppImageAPIService(dio: dio);
  }
}
