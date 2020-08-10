// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _SearchApiClient implements SearchApiClient {
  _SearchApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> getSearchAutoComplete(String query) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final Response<String> _result = await _dio.request(
        '/search_products_auto_complete/$query',
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
  Future<String> searchProducts(
      String query, String pageNumber, SearchBody searchBody) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'page': pageNumber};
    final _data = searchBody ==  null?{}:searchBody.toJson();
    Logger().d("SEARCH INPUTS: $_data");

    final Response<String> _result = await _dio.request(
        '/search_products/$query',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("PRODUCT SEARCH REQUEST:${_result.data}");
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getSearchHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final Response<String> _result = await _dio.request('/get_search_history/',
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
