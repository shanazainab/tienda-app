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
  Future<String> addSavedAddress(Customer customer) {
      const _extra = <String, dynamic>{};
/*    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'product_id': productId};

    final Response<String> _result = await _dio.request('/delete_from_cart/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;*/
  }

  @override
  Future<String> deleteSavedAddress() {
    // TODO: implement deleteSavedAddress
    throw UnimplementedError();
  }

  @override
  Future<String> editSavedAddress() {
    // TODO: implement editSavedAddress
    throw UnimplementedError();
  }

  @override
  Future<String> getSavedAddress() {
    // TODO: implement getSavedAddress
    throw UnimplementedError();
  }
}
