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
}
