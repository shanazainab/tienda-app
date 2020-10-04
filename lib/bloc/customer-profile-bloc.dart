import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';








class CustomerProfileBloc
    extends Bloc<CustomerProfileEvents, CustomerProfileStates> {
  CustomerProfileBloc() : super(Loading());


  @override
  Stream<CustomerProfileStates> mapEventToState(
      CustomerProfileEvents event) async* {
    if (event is OfflineLoadCustomerData) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Customer customer = Customer.fromJson(
          json.decode(sharedPreferences.getString("customer")));
      yield OfflineLoadCustomerDataSuccess(customerDetails: customer);
    }
    if (event is FetchCustomerProfile) {
      yield* _mapFetchCustomerProfileToStates(event);
    }
    if (event is EditCustomerProfile) {
      yield* _mapEditCustomerProfileToStates(event);
    }

    if (event is UpdateProfilePicture) {
      yield* _mapUpdateProfilePictureToStates(event);
    }
  }

  Stream<CustomerProfileStates> _mapUpdateProfilePictureToStates(
      UpdateProfilePicture event) async* {
    ///convert file image to base64
    List<int> imageBytes = event.profileImage.readAsBytesSync();
    print(imageBytes);
    String encodedImage = base64Encode(imageBytes);

    /// data:image/jpeg;base64,

    String mimeType = mime(event.profileImage.path);

    String formattedCode = 'data:$mimeType;base64,$encodedImage';

    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

    String status;
    await customerProfileApiClient
        .updateProfilePicture(formattedCode)
        .then((response) {
      Logger().d("EDIT-CUSTOMER-PROFILE-PICTURE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("EDIT-CUSTOMER-PROFILE-PICTURE-ERROR:", error.response.data);
      }
    });

    Customer customer = await callFetchCustomerProfileApi();
    Logger().e("customer:$customer");

    if (customer != null) {
      updateCustomerProfileLocally(customer);
      yield LoadCustomerProfileSuccess(customerDetails: customer);
    }
  }

  Stream<CustomerProfileStates> _mapEditCustomerProfileToStates(
      EditCustomerProfile event) async* {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('customer-name', event.customer.fullName);
    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

    String status;
    await customerProfileApiClient
        .editCustomerDetails(event.customer)
        .then((response) {
      Logger().d("EDIT-CUSTOMER-PROFILE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("EDIT-CUSTOMER-PROFILE-ERROR:", error);
      }
    });
    Customer customer = await callFetchCustomerProfileApi();
    Logger().e("customer:$customer");

    if (customer != null) {
      updateCustomerProfileLocally(customer);
      yield LoadCustomerProfileSuccess(customerDetails: customer);
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Customer customer = Customer.fromJson(
          json.decode(sharedPreferences.getString("customer")));
      yield LoadCustomerProfileSuccess(customerDetails: customer);
    }
  }

  Future<Customer> callFetchCustomerProfileApi() async {
    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    Customer customer;

    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));
    await customerProfileApiClient.getCustomerProfile().then((response) {
      Logger().d("GET-CUSTOMER-PROFILE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          customer = Customer.fromJson(json.decode(response)['profile']);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("GET-CUSTOMER-PROFILE-ERROR:", error);
      }
    });

    return customer;
  }

  Stream<CustomerProfileStates> _mapFetchCustomerProfileToStates(
      FetchCustomerProfile event) async* {
    Customer customer = await callFetchCustomerProfileApi();

    if (customer != null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt('customer-id', customer.id);
      sharedPreferences.setString('customer-name', customer.fullName);
      updateCustomerProfileLocally(customer);
      yield LoadCustomerProfileSuccess(customerDetails: customer);
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if(sharedPreferences.containsKey("customer")) {
        Customer customer = Customer.fromJson(
            json.decode(sharedPreferences.getString("customer")));
        yield LoadCustomerProfileSuccess(customerDetails: customer);
      }
      else{
        yield NoCustomerData();

      }
    }

  }

  Future<void> updateCustomerProfileLocally(Customer customer) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("customer", customerToJson(customer));
  }
}
