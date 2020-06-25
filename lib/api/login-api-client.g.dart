// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _LoginApiClient implements LoginApiClient {
  _LoginApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  sendOTP(loginRequest) async {
    ArgumentError.checkNotNull(loginRequest, 'loginRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginRequest?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/phone_login/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(loginVerifyRequest) async {
    ArgumentError.checkNotNull(loginVerifyRequest, 'loginVerifyRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(loginVerifyRequest?.toJson() ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/verify_phone/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    /*var value = _result.data.map((k, dynamic v) =>
        MapEntry(k, dynamic.fromJson(v as Map<String, dynamic>)));*/

    Map<String, dynamic> response = {
      'headers': _result.headers.map,
      'body': _result.data
    };
    return response;
  }

  @override
  checkGoogleToken(accessToken) async {
    ArgumentError.checkNotNull(accessToken, 'accessToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = accessToken;
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/check_google_token/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    /* var value = _result.data.map((k, dynamic v) =>
        MapEntry(k, dynamic.fromJson(v as Map<String, dynamic>)));*/

    Map<String, dynamic> response = {
      'headers': _result.headers.map,
      'body': _result.data
    };
    return response;
  }

  @override
  checkFacebookToken(accessToken) async {
    ArgumentError.checkNotNull(accessToken, 'accessToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = accessToken;
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/check_facebook_token/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Map<String, dynamic> response = {
      'headers': _result.headers.map,
      'body': _result.data
    };
    return response;
  }

  @override
  getGuestLoginSessionId(deviceId) async {
    ArgumentError.checkNotNull(deviceId, 'deviceId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"device-id":deviceId};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/get_cookie/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Map<String, dynamic> response = {
      'headers': _result.headers.map,
      'body': _result.data
    };
    return response;
  }

  @override
  logout() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/customer_logout/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<String> checkCookie() async {
     const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/check_cookie/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }
}
