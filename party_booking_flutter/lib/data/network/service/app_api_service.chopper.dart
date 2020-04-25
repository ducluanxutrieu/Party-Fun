// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$AppApiService extends AppApiService {
  _$AppApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AppApiService;

  @override
  Future<Response<AccountResponseModel>> requestSignIn(
      {LoginRequestModel model}) {
    final $url = 'user/signin';
    final $body = model;
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
    final $url = 'product/finddish';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client
        .send<ListDishesResponseModel, ListDishesResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> requestResetPassword(
      {ChangePasswordRequestModel model}) {
    final $url = 'user/resetpassword';
    final $body = model;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> confirmResetPassword(
      {ConfirmResetPasswordRequestModel model}) {
    final $url = 'user/resetconfirm';
    final $body = model;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<BaseResponseModel>> requestSignOut({String token}) {
    final $url = 'user/signout';
    final $headers = {'authorization': token};
    final $request = Request('POST', $url, client.baseUrl, headers: $headers);
    return client.send<BaseResponseModel, BaseResponseModel>($request);
  }

  @override
  Future<Response<AccountResponseModel>> requestUpdateUser(
      {String token, UpdateProfileRequestModel model}) {
    final $url = 'user/updateuser';
    final $headers = {'authorization': token};
    final $body = model;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
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
    final $url = 'user/profile';
    final $headers = {'authorization': token};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<AccountResponseModel, AccountResponseModel>($request);
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
      {String token, GetPaymentRequestModel mode}) {
    final $url = 'payment/get_payment';
    final $headers = {'authorization': token};
    final $body = mode;
    final $request =
        Request('GET', $url, client.baseUrl, body: $body, headers: $headers);
    return client
        .send<GetPaymentResponseModel, GetPaymentResponseModel>($request);
  }
}
