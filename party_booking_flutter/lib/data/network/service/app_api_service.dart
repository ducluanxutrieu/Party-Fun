import 'package:chopper/chopper.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/login_request_model.dart';
import 'package:party_booking/data/network/model/login_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';

import '../interceptor/network_interceptor.dart';
import 'json_serializable_converter.dart';

part 'app_api_service.chopper.dart';

@ChopperApi()
abstract class AppApiService extends ChopperService {
  @Post(path: 'user/signin')
  Future<Response<AccountResponseModel>> requestSignIn({
    @body LoginRequestModel model,
  });

  @Post(path: 'user/signup')
  Future<Response<BaseResponseModel>> requestRegister({
    @body RegisterRequestModel model,
  });

  @Get(path: 'product/finddish')
  Future<Response<ListDishesResponseModel>> getListDishes({
    @Header('authorization') String token,
  });

  @Post(path: 'user/resetpassword')
  Future<Response<BaseResponseModel>> requestResetPassword({
    @body ChangePasswordRequestModel model,
  });

  @Post(path: 'user/resetconfirm')
  Future<Response<BaseResponseModel>> confirmResetPassword({
  @body ConfirmResetPasswordRequestModel model,
});

  @Post(path: 'user/signout')
  Future<Response<BaseResponseModel>> requestSignOut({
    @Header('authorization') String token,
});

  static AppApiService create() {
    final client = ChopperClient(
        baseUrl: 'http://139.180.131.30:3000/',
        services: [
          _$AppApiService(),
        ],
        converter: _converter,
        errorConverter: JsonConverter(),
        interceptors: [
          HttpLoggingInterceptor(),
          NetworkInterceptor(),
        ]);
    return _$AppApiService(client);
  }

  static JsonSerializableConverter get _converter {
    return JsonSerializableConverter({
      AccountResponseModel: AccountResponseModel.fromJsonFactory,
      RegisterRequestModel: RegisterRequestModel.fromJsonFactory,
      ListDishesResponseModel: ListDishesResponseModel.fromJsonFactory,
      DishModel: DishModel.fromJsonFactory,
      RateModel: RateModel.fromJsonFactory,
      RateItemModel: RateItemModel.fromJsonFactory,
      LoginResponseModel: LoginResponseModel.fromJsonFactory,
      BaseResponseModel: BaseResponseModel.fromJsonFactory,
    });
  }
}
