import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/bloc/events/profile-events.dart';
import 'package:tienda/bloc/states/profile-states.dart';
import 'package:dio/dio.dart';
import 'package:tienda/model/customer.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileStates> {
  @override
  ProfileStates get initialState => Loading();

  @override
  Stream<ProfileStates> mapEventToState(ProfileEvents event) async* {
    if (event is FetchCustomerProfile) {
      yield* _mapFetchCustomerProfileToStates(event);
    }
  }

  Stream<ProfileStates> _mapFetchCustomerProfileToStates(
      FetchCustomerProfile event) async* {
    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;

    Customer customer;

    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));
    await customerProfileApiClient.getCustomerProfile().then((response) {
      print("#########");
      print("GET-CUSTOMER-PROFILE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          customer = Customer.fromJson(json.decode(response)['profile']);
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;
        print('%%%%%%%%%');
        print("GET-CUSTOMER-PROFILE-ERROR:${error.response}");

        print("GET-CUSTOMER-PROFILE-ERROR:${error.response?.data}");
        print('%%%%%REQUEST%%%%');

        print("GET-CUSTOMER-PROFILE-ERROR:${error.request?.data}");
      }
    });

    if (customer != null) yield LoadCustomerProfileSuccess(customerDetails: customer);
  }
}
