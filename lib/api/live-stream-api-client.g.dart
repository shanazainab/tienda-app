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
}
