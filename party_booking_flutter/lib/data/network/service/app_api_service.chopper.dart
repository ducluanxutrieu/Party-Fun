// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$AppApiService extends AppApiService {
  _$AppApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AppApiService;

  @override
  Future<Response<AccountResponseModel>> requestSignIn(
      {String username, String password}) {
    final $url = 'user/signin';
    final $body = <String, dynamic>{'username': username, 'password': password};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AccountResponseModel, AccountResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> requestRegister(
      {RegisterRequestModel model}) {
    final $url = 'user/signup';
    final $body = model;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<ListDishesResponseModel>> getListDishes({String token}) {
    final $url = 'product/dishs';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<ListDishesResponseModel, ListDishesResponseModel>($request);
  }

  @override
  Future<Response<DishDetailResponseModel>> getDishDetail(
      {String token, String dishId}) {
    final $url = 'product/dish/$dishId';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<DishDetailResponseModel, DishDetailResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> resetPassword({String username}) {
    final $url = 'user/reset_password';
    final $params = <String, dynamic>{'username': username};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> confirmResetPassword(
      {ConfirmResetPasswordRequestModel model}) {
    final $url = 'user/confirm_otp';
    final $body = model;
    final $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> changePassword(
      {String token, ConfirmChangePasswordRequestModel model}) {
    final $url = 'user/change_pwd';
    final $headers = {'authorization': token};
    final $body = model;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> requestSignOut({String token}) {
    final $url = 'user/signout';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<AccountResponseModel>> requestUpdateUser(
      {String token, UpdateProfileRequestModel model}) {
    final $url = 'user/update';
    final $headers = {'authorization': token};
    final $body = model;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<AccountResponseModel, AccountResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> requestRating(
      {String token, RateDishRequestModel model}) {
    final $url = 'product/ratedish';
    final $headers = {'authorization': token};
    final $body = model;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<AccountResponseModel>> getUserProfile({String token}) {
    final $url = 'user/get_me';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<AccountResponseModel, AccountResponseModel>($request);
  }

  @override
  Future<Response<GetHistoryCartModel>> getUserHistory({String token}) {
    final $url = 'user/get_history_cart';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<GetHistoryCartModel, GetHistoryCartModel>($request);
  }

  @override
  Future<Response<PartyBookResponseModel>> bookParty(
      {String token, BookPartyRequestModel model}) {
    final $url = 'product/book';
    final $headers = {'authorization': token};
    final $body = model;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<PartyBookResponseModel, PartyBookResponseModel>($request);
  }

  @override
  Future<Response<GetPaymentResponseModel>> getPayment(
      {String token, String id}) {
    final $url = 'payment/get_payment';
    final $params = <String, dynamic>{'_id': id};
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client
        .send<GetPaymentResponseModel, GetPaymentResponseModel>($request);
  }

  @override
  Future<Response<UpdateDishResponseModel>> updateDish(
      {String token, Map<String, dynamic> data}) {
    final $url = 'product/dish';
    final $headers = {'authorization': token};
    final $body = data;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<UpdateDishResponseModel, UpdateDishResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> deleteDish({String token, String id}) {
    final $url = 'product/deletedish';
    final $headers = {'authorization': token};
    final $body = <String, dynamic>{'_id': id};
    final $request =
        Request('DELETE', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<ListPostsResponseModel>> getListPosts({String token}) {
    final $url = 'product/posts';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<ListPostsResponseModel, ListPostsResponseModel>($request);
  }
}
