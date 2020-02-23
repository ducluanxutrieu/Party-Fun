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
    final $url = '/user/signin';
    final $body = model;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AccountResponseModel, AccountResponseModel>($request);
  }
}
