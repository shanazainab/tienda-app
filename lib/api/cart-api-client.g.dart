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
  addToCart(productId, quantity) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity
    };

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

  @override
  Future<String> cartCheckout(
      int addressId, PaymentCard paymentCard, int cardId, int cvv) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'address_id': addressId,
      "card": paymentCard.toJson(),
      if (cardId != null) "card_id": cardId,
      if (cvv != null) "cvv": cvv
    };

    print("DATA: $_data");

    final Response<String> _result = await _dio.request('/checkout/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    Logger().e("CART CHECKOUT REQUEST: ${_result.request.data}");
    return value;
  }

  @override
  Future<String> getCart() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<String> _result = await _dio.request('/get_cart/',
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
  Future<String> changeQuantity(int productId, int quantity) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity
    };
    final Response<String> _result = await _dio.request(
        '/change_cart_product_quantity/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    Logger().e("CART CHECKOUT REQUEST: ${_result.request.data}");
    return value;
  }

  @override
  Future<String> applyCoupon(String coupon) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'coupon': coupon,
    };
    final Response<String> _result = await _dio.request('/redeem_coupon/',
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
  Future<String> removeAppliedCoupon(String couponCode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      'coupon': couponCode,
    };
    final Response<String> _result = await _dio.request('/remove_coupon/',
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
