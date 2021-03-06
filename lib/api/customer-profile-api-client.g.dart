// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer-profile-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _CustomerProfileApiClient implements CustomerProfileApiClient {
  _CustomerProfileApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  registerCustomerDetails(customer) async {
    ArgumentError.checkNotNull(customer, 'customer');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customer?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/phone_register/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    print("REGISTER CUSTOMER PROFILE REQUEST: ${_result.request.data}");

    final value = _result.data;
    return value;
  }

  @override
  getCustomerProfile() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/get_profile/',
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
  Future<String> editCustomerDetails(Customer customer) async {
    ArgumentError.checkNotNull(customer, 'customer');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(customer?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/update_profile/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);

    print("REGISTER CUSTOMER PROFILE REQUEST: ${_result.request.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> updateProfilePicture(String encodedImage) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'profile_picture': encodedImage};
    Logger().d("REQUEST:${_data}");

    final Response<String> _result = await _dio.request(
        '/change_profile_picture/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("REQUEST:${_result.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> changePhoneNumber(String phoneNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'phone_number': phoneNumber};

    final Response<String> _result = await _dio.request('/change_phone_number/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("REQUEST:${_result.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> verifyUpdatedPhoneNumber(
      String phoneNumber, String otp) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'phone_number': phoneNumber, "totp": otp};

    final Response<String> _result = await _dio.request(
        '/verify_update_phone_number/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("REQUEST:${_result.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getWatchHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/get_watch_history/',
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
