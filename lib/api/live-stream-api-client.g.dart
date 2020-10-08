// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live-stream-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _LiveStreamApiClient implements LiveStreamApiClient {
  _LiveStreamApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> joinTheLive(int presenterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{'presenter_id': presenterId};

    final Response<String> _result = await _dio.request('/join_presenter_live/',
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
  Future<String> getReviews(int presenterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final Response<String> _result = await _dio.request('/get_presenter_review_box/$presenterId',
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
  Future<String> reviewPresenter(int presenterId, PresenterReview presenterReview) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = presenterReview.toJson();

    final Response<String> _result = await _dio.request('/review_presenter/$presenterId',
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
