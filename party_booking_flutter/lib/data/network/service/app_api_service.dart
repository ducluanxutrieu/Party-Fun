import 'package:chopper/chopper.dart';
import 'package:party_booking/data/network/model/account_response_model.dart';
import 'package:party_booking/data/network/model/base_response_model.dart';
import 'package:party_booking/data/network/model/book_party_request_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model.dart';
import 'package:party_booking/data/network/model/change_password_request_model_2.dart';
import 'package:party_booking/data/network/model/dish_create_request_model.dart';
import 'package:party_booking/data/network/model/get_dish_detail_response_model.dart';
import 'package:party_booking/data/network/model/get_history_cart_model.dart';
import 'package:party_booking/data/network/model/get_payment_response_mode.dart';
import 'package:party_booking/data/network/model/list_categories_response_model.dart';
import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:party_booking/data/network/model/list_posts_response_model.dart';
import 'package:party_booking/data/network/model/login_response_model.dart';
import 'package:party_booking/data/network/model/party_book_response_model.dart';
import 'package:party_booking/data/network/model/rate_dish_request_model.dart';
import 'package:party_booking/data/network/model/rate_dish_response_model.dart';
import 'package:party_booking/data/network/model/register_request_model.dart';
import 'package:party_booking/data/network/model/update_dish_response_model.dart';
import 'package:party_booking/data/network/model/update_profile_request_model.dart';

import 'json_serializable_converter.dart';

part 'app_api_service.chopper.dart';

@ChopperApi()
abstract class AppApiService extends ChopperService {
  @Post(path: 'user/signin')
  Future<Response<AccountResponseModel>> requestSignIn({
    @Field('username') String username,
    @Field('password') String password,
  });

  @Post(path: 'user/signup')
  Future<Response<AccountResponseModel>> requestRegister({
    @body RegisterRequestModel model,
  });

  @Get(path: 'product/dishs')
  Future<Response<ListDishesResponseModel>> getListDishes({
    @Header('authorization') String token,
  });

  @Get(path: 'product/dish/{dishId}')
  Future<Response<DishDetailResponseModel>> getDishDetail(
      {@Header('authorization') String token, @Path() String dishId});

  @Get(path: 'user/reset_password')
  Future<Response<BaseResponseModel>> resetPassword({
    @Query('username') String username,
  });

  @Put(path: 'user/confirm_otp')
  Future<Response<BaseResponseModel>> confirmResetPassword({
    @body ConfirmResetPasswordRequestModel model,
  });

  @Put(path: 'user/change_pwd')
  Future<Response<BaseResponseModel>> changePassword(
      {@Header('authorization') String token,
      @body ConfirmChangePasswordRequestModel model});

  @Get(path: 'user/signout')
  Future<Response<BaseResponseModel>> requestSignOut({
    @Header('authorization') String token,
  });

  @Put(path: 'user/update')
  Future<Response<AccountResponseModel>> requestUpdateUser(
      {@Header('authorization') String token,
      @body UpdateProfileRequestModel model});

  @Post(path: 'product/rate')
  Future<Response<BaseResponseModel>> requestRating({
    @Header('authorization') String token,
    @body RateDishRequestModel model,
  });

  @Put(path: 'product/rate')
  Future<Response<BaseResponseModel>> updateRating({
    @Header('authorization') String token,
    @body RateDishRequestModel model,
  });

  @Get(path: 'user/get_me')
  Future<Response<AccountResponseModel>> getUserProfile({
    @Header('authorization') String token,
  });

  @Get(path: 'user/get_history_cart')
  Future<Response<GetHistoryCartModel>> getUserHistory({
    @Header('authorization') String token,
    @Query('page') int page,
  });

  @Post(path: 'product/book')
  Future<Response<PartyBookResponseModel>> bookParty({
    @Header('authorization') String token,
    @body BookPartyRequestModel model,
  });

  @Get(path: 'payment/get_payment')
  Future<Response<GetPaymentResponseModel>> getPayment({
    @Header('authorization') String token,
    @Query('_id') String id,
  });
  @Get(path: 'product/rate')
  Future<Response<RateResponseModelData>> getRate(
    @Query('id') String id,
    @Query('page') int page,
  );
  @Post(path: 'product/dish')
  Future<Response<SingleDishResponseModel>> addNewDish({
    @Header('authorization') String token,
    @body DishRequestCreateModel model,
  });

  @Put(path: 'product/dish')
  Future<Response<UpdateDishResponseModel>> updateDish({
    @Header('authorization') String token,
    @body DishModel model,
  });

  @Delete(path: 'product/dish')
  Future<Response<BaseResponseModel>> deleteDish(
      {@Header('authorization') String token, @Field('_id') String id});

  //Post
  @Get(path: 'product/posts')
  Future<Response<ListPostsResponseModel>> getListPosts({
    @Header('authorization') String token,
    @Query('page') int page,
  });

  @Get(path: 'product/categories')
  Future<Response<ListCategoriesResponseModel>> getCategories();

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
        ]);
    return _$AppApiService(client);
  }

  static JsonSerializableConverter get _converter {
    return JsonSerializableConverter({
      AccountResponseModel: AccountResponseModel.fromJsonFactory,
      RegisterRequestModel: RegisterRequestModel.fromJsonFactory,
      ListDishesResponseModel: ListDishesResponseModel.fromJsonFactory,
      DishModel: DishModel.fromJsonFactory,
      //  RateModel: RateModel.fromJsonFactory,
      // RateItemModel: RateItemModel.fromJsonFactory,
      LoginResponseModel: LoginResponseModel.fromJsonFactory,
      BaseResponseModel: BaseResponseModel.fromJsonFactory,
      RateResponseModelData: RateResponseModelData.fromJsonFactory,
      UpdateProfileRequestModel: UpdateProfileRequestModel.fromJsonFactory,
      RateDishRequestModel: RateDishRequestModel.fromJsonFactory,
      BookPartyRequestModel: BookPartyRequestModel.fromJsonFactory,
      PartyBookResponseModel: PartyBookResponseModel.fromJsonFactory,
      GetPaymentResponseModel: GetPaymentResponseModel.fromJsonFactory,
      UpdateDishResponseModel: UpdateDishResponseModel.fromJsonFactory,
      ListPostsResponseModel: ListPostsResponseModel.fromJsonFactory,
      DisplayItem: DisplayItem.fromJsonFactory,
      Custom: Custom.fromJsonFactory,
      GetHistoryCartModel: GetHistoryCartModel.fromJsonFactory,
      SingleDishResponseModel: SingleDishResponseModel.fromJsonFactory,
      ListCategoriesResponseModel: ListCategoriesResponseModel.fromJsonFactory,
    });
  }
}
