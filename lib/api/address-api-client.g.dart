// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AddressApiClient implements AddressApiClient {
  _AddressApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> addSavedAddress(DeliveryAddress address) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = address.toJson();

    final Response<String> _result = await _dio.request('/add_address/',
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
  Future<String> deleteSavedAddress(int addressId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"address_id": addressId};

    final Response<String> _result = await _dio.request('/delete_address/',
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
  Future<String> editSavedAddress(DeliveryAddress address) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = address.toJson();

    final Response<String> _result = await _dio.request('/edit_address/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("EDIT ADDRESS: ${_result.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getSavedAddress() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};

    final Response<String> _result = await _dio.request(
      '/get_addresses/',
      queryParameters: queryParameters,
      options: RequestOptions(
          method: 'GET',
          headers: <String, dynamic>{},
          extra: _extra,
          baseUrl: baseUrl),
    );
    final value = _result.data;
    return value;
  }
}
