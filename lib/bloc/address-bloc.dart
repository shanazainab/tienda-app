import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/address-api-client.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/states/address-states.dart';
import 'package:tienda/model/delivery-address.dart';

class AddressBloc extends Bloc<AddressEvents, AddressStates> {
  AddressBloc() : super(Loading());



  @override
  Stream<AddressStates> mapEventToState(AddressEvents event) async* {
    if (event is LoadSavedAddress) {
      yield* _mapLoadSavedAddressToStates(event);
    }
    if (event is AddSavedAddress) {
      yield* _mapAddSavedAddressToStates(event);
    }

    if (event is DeleteSavedAddress) {
      yield* _mapDeleteSavedAddressToStates(event);
    }

    if (event is EditSavedAddress) {
      yield* _mapEditSavedAddressToStates(event);
    }
  }

  Stream<AddressStates> _mapLoadSavedAddressToStates(
      LoadSavedAddress event) async* {
    yield Loading();
    List<DeliveryAddress> addresses = await callLoadAddressApi();
    if (addresses.isNotEmpty)
      yield LoadAddressSuccess(deliveryAddresses: addresses);
    else if (addresses.isEmpty)
      yield AddressEmpty();
    else
      yield AuthorizationFailed();
  }

  Future<List<DeliveryAddress>> callLoadAddressApi() async {
    List<DeliveryAddress> addresses = new List();
    final dio = Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = AddressApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.getSavedAddress().then((response) {
      Logger().d("GET-SAVED-ADDRESS-RESPONSE:$response");

      DeliverAddressResponse data = deliverAddressResponseFromJson(response);
      switch (data.status) {
        case 200:
          if (data.addresses.isNotEmpty) {
            addresses = data.addresses;
          }

          break;
        case 401:
          addresses = null;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("GET-SAVED-ADDRESS-ERROR:${error}");
        Logger().e("GET-SAVED-ADDRESS-DATA:${error.response?.data}");
        Logger().e("GET-SAVED-ADDRESS-REQUEST:${error.request?.data}");
      }
    });

    return addresses;
  }

  Stream<AddressStates> _mapAddSavedAddressToStates(
      AddSavedAddress event) async* {
    yield Loading();

    final dio = Dio();
    String status;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = AddressApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.addSavedAddress(event.deliveryAddress).then((response) {
      Logger().d("ADD-TO-SAVED-ADDRESS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 401:
          status = "Not Authorized";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("ADD-TO-SAVED-ADDRESS-ERROR:${error.response}");
        Logger().e("ADD-TO-SAVED-ADDRESS-DATA:${error.response?.data}");
        Logger().e("ADD-TO-SAVED-ADDRESS-REQUEST:${error.request?.data}");
      }
    });
    if (status == "success") {
      List<DeliveryAddress> addresses = await callLoadAddressApi();
      if (addresses.isNotEmpty)
        yield LoadAddressSuccess(deliveryAddresses: addresses);
    }
  }

  Stream<AddressStates> _mapEditSavedAddressToStates(
      EditSavedAddress event) async* {
    final dio = Dio();
    String status;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = AddressApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.editSavedAddress(event.deliveryAddress).then((response) {
      Logger().d("EDIT-SAVED-ADDRESS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 401:
          status = "Not Authorized";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("EDIT-SAVED-ADDRESS-ERROR:${error.response}");
        Logger().e("EDIT-SAVED-ADDRESS-DATA:${error.response?.data}");
        Logger().e("EDIT-SAVED-ADDRESS-REQUEST:${error.request?.data}");
      }
    });
    if (status == "success") {
      List<DeliveryAddress> addresses = await callLoadAddressApi();
      if (addresses.isNotEmpty)
        yield LoadAddressSuccess(deliveryAddresses: addresses);
    }

    //if (status == "Not Authorized") yield AuthorizationFailed();
  }

  Stream<AddressStates> _mapDeleteSavedAddressToStates(
      DeleteSavedAddress event) async* {
    final dio = Dio();
    String status;
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    final client = AddressApiClient(dio,
        baseUrl: GlobalConfiguration().getString("baseURL"));
    await client.deleteSavedAddress(event.deliveryAddressId).then((response) {
      Logger().d("DELETE-SAVED-ADDRESS-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
        case 401:
          status = "Not Authorized";
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        Logger().e("DELETE-SAVED-ADDRESS-ERROR:${error.response}");
        Logger().e("DELETE-SAVED-ADDRESS-DATA:${error.response?.data}");
        Logger().e("DELETE-SAVED-ADDRESS-REQUEST:${error.request?.data}");
      }
    });

    ///update UI
    event.deliveryAddresses
        .removeWhere((element) => element.id == event.deliveryAddressId);
    if (status == "success")
      yield DeleteAddressSuccess(deliveryAddresses: event.deliveryAddresses);
    //if (status == "Not Authorized") yield AuthorizationFailed();
  }
}

DeliverAddressResponse deliverAddressResponseFromJson(String str) =>
    DeliverAddressResponse.fromJson(json.decode(str));

String deliverAddressResponseToJson(DeliverAddressResponse data) =>
    json.encode(data.toJson());

class DeliverAddressResponse {
  DeliverAddressResponse({
    this.status,
    this.addresses,
  });

  int status;
  List<DeliveryAddress> addresses;

  factory DeliverAddressResponse.fromJson(Map<String, dynamic> json) =>
      DeliverAddressResponse(
        status: json["status"],
        addresses: List<DeliveryAddress>.from(
            json["addresses"].map((x) => DeliveryAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
      };
}
