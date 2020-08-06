// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ChatApiClient implements ChatApiClient {
  _ChatApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> createMessage(String senderId, String receiverId,
      String message, String socketId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'sender_id': senderId,
      'reciever_id': receiverId,
      'message': message,
      'socket_id': socketId
    };

    final Response<String> _result = await _dio.request('api/v1/message',
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
  Future<String> getAllMessages() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final Response<String> _result = await _dio.request('api/v1/message',
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
  Future<String> getConversation(String senderId, String receiverId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final Response<String> _result = await _dio.request(
        'api/v1/message/$senderId/$receiverId',
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
