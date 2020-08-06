// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ReviewApiClient implements ReviewApiClient {
  _ReviewApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> addReview(ReviewRequest reviewRequest) async {
    // TODO: implement addReview
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = reviewRequest.toJson();
    final Response<String> _result = await _dio.request('/add_review/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    Logger().d("CUSTOMER REVIEW REQUEST:${_result.request.data}");
    final value = _result.data;
    return value;
  }
}
