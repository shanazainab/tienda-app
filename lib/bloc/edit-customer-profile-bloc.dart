import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:tienda/api/customer-profile-api-client.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';

class EditCustomerProfileBloc
    extends Bloc<CustomerProfileEvents, CustomerProfileStates> {
  EditCustomerProfileBloc() : super(Loading());

  @override
  Stream<CustomerProfileStates> mapEventToState(
      CustomerProfileEvents event) async* {
    if (event is ChangePhoneNumber) {
      yield* _mapFetchChangePhoneNumberToStates(event);
    }
    if (event is VerifyPhoneNumber) {
      yield* _mapFetchVerifyPhoneNumberToStates(event);
    }
    // if (event is ChangeEmail) {
    //   yield* _mapEditChangeEmailToStates(event);
    // }
    //
    // if (event is VerifyEmail) {
    //   yield* _mapVerifyEmailToStates(event);
    // }
  }

  Stream<CustomerProfileStates> _mapFetchChangePhoneNumberToStates(
      ChangePhoneNumber event) async* {
    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

    String status;
    await customerProfileApiClient
        .changePhoneNumber(event.phoneNumber)
        .then((response) {
      Logger().d("EDIT-CUSTOMER-PROFILE-CHANGE-PHONE-NUMBER:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("EDIT-CUSTOMER-PROFILE-CHANGE-PHONE-NUMBER-ERROR:",
            error.response.data);
      }
    });

    if(status == "success")
      yield ChangePhoneNumberSuccess();
  }

  Stream<CustomerProfileStates> _mapFetchVerifyPhoneNumberToStates(
      VerifyPhoneNumber event) async* {
    final dio = new Dio();
    String value = await FlutterSecureStorage().read(key: "session-id");
    dio.options.headers["Cookie"] = value;
    CustomerProfileApiClient customerProfileApiClient =
        CustomerProfileApiClient(dio,
            baseUrl: GlobalConfiguration().getString("baseURL"));

    String status;
    await customerProfileApiClient
        .verifyUpdatedPhoneNumber(event.phoneNumber, event.otp)
        .then((response) {
      Logger().d("EDIT-CUSTOMER-VERIFY-PHONE-RESPONSE:$response");
      switch (json.decode(response)['status']) {
        case 200:
          status = "success";
          break;
      }
    }).catchError((err) {
      if (err is DioError) {
        DioError error = err;

        Logger().e("EDIT-CUSTOMER-VERIFY-PHONE-ERROR:", error);
      }
    });
    if(status == "success")
      yield VerifyPhoneNumberSuccess();
  }
}
