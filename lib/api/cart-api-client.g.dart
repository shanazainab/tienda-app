// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _CartApiClient implements CartApiClient {
  _CartApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  addToCart(productId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'product_id': productId};

    final Response<String> _result = await _dio.request('/add_to_cart/',
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
  Future<String> deleteFromCart(int productId) async {
       const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
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
    return value;
  }
}
