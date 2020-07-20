// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ProductApiClient implements ProductApiClient {
  _ProductApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  getProductsByCategory(String categoryId, String pageNumber) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'page': pageNumber};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request(
        '/get_products_by_category/$categoryId',
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
  Future<String> getProductDetailsByCategory(String productId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request(
        '/get_product_details/$productId',
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
