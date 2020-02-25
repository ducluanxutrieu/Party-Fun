import 'package:chopper/chopper.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/login_request_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';

import '../interceptor/network_interceptor.dart';
import 'built_value_converter.dart';

part 'app_api_service.chopper.dart';

@ChopperApi()
abstract class AppApiService extends ChopperService {
  @Post(path: '/user/signin')
  Future<Response<AccountResponseModel>> requestSignIn({
    @body LoginRequestModel model,
  });

  @Post(path: '/user/signup')
  Future<Response<AccountResponseModel>> requestRegister({
    @body RegisterRequestModel model,
  });

  @Get(path: '/product/finddish')
  Future<Response<ListDishesResponseModel>> getListDishes({
    @Header('authorization') String token,
  });

  static AppApiService create() {
    final client = ChopperClient(
        baseUrl: 'http://139.180.131.30:3000',
        services: [
          _$AppApiService(),
        ],
        converter: BuiltValueConverter(),
        errorConverter: JsonConverter(),
        interceptors: [
          HttpLoggingInterceptor(),
          NetworkInterceptor(),
        ]);
    return _$AppApiService(client);
  }
}
