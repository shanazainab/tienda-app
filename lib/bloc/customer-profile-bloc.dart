import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';

class CustomerProfileBloc
    extends Bloc<CustomerProfileEvents, CustomerProfileStates> {
  @override
  CustomerProfileStates get initialState => Loading();

  @override
  Stream<CustomerProfileStates> mapEventToState(
      CustomerProfileEvents event) async* {
    if (event is FetchCustomerProfile) {
      yield* _mapFetchCustomerProfileToStates(event);
    }
    if (event is EditCustomerProfile) {
      yield* _mapEditCustomerProfileToStates(event);
    }
  }

  Stream<CustomerProfileStates> _mapEditCustomerProfileToStates(
      EditCustomerProfile event) async* {
    print("CALLED");

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
    print("CALLEDs");

    if(status == "success")
    yield EditCustomerProfileSuccess(
      customer: event.customer
    );
  }

  Stream<CustomerProfileStates> _mapFetchCustomerProfileToStates(
      FetchCustomerProfile event) async* {
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

    if (customer != null)
      yield LoadCustomerProfileSuccess(customerDetails: customer);
  }
}
