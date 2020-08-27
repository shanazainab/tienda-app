import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tienda/api/login-api-client.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/controller/login-controller.dart';
import 'events/login-events.dart';
import 'package:dio/dio.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  LoginBloc() : super(LoginInitiated());



  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async* {
    if (event is CheckLoginStatus){
      yield* _doCheckLogin(event);}
    else if (event is SendOTP)
      yield* _doLoginSendOTP(event);
    else if (event is VerifyOTP)
      yield* _doLoginVerifyOTP(event);
    else if (event is RegisterCustomer)
      yield* _doCustomerRegistration(event);
    else if (event is Logout)
      yield* _doLogout(event);
    else if (event is DoGoogleSignIn)
      yield* _doGoogleSignIn(event);
    else if (event is DoFacebookSignIn) yield* _doFacebookSignIn(event);
  }

  Stream<LoginStates> _doCheckLogin(CheckLoginStatus event) async* {
    bool isLoggedIn = await LoginController().checkLoginStatus();
    if (isLoggedIn)
      yield LoggedInUser();
    else
      yield GuestUser();
  }

  Stream<LoginStates> _doLoginSendOTP(SendOTP event) async* {
    final loginRequest = event.loginRequest;
    yield LoginInProgress();

    ///call backend api for login send

    String status = await LoginController().signWithMobileNumber(loginRequest);
    if (status == "success")
      yield LoginSendOTPSuccess("success");
    else
      yield LoginSendOTPError(error: "Something went wrong");
  }

  Stream<LoginStates> _doLoginVerifyOTP(VerifyOTP event) async* {
    final loginVerifyRequest = event.loginVerifyRequest;
    yield LoginInProgress();

    ///call backend api for login verify

    String status = await LoginController().verifyLoginOTP(loginVerifyRequest);
    if (status == "Existing User")
      yield LoginVerifyOTPSuccess(isNewUser: false);
    if (status == "New User")
      yield LoginVerifyOTPSuccess(isNewUser: true);
    else
      yield LoginVerifyOTPError(error: status);
  }

  Stream<LoginStates> _doCustomerRegistration(RegisterCustomer event) async* {
    await LoginController().registerCustomer(event.customer);
    yield CustomerRegistrationSuccess();
  }

  Stream<LoginStates> _doLogout(Logout event) async* {
    String status = await LoginController().logOut();

    switch (status) {
      case "success":
        yield LogoutSuccess();
        break;
      case "failed":
        yield LogoutError();
    }
  }

  Stream<LoginStates> _doGoogleSignIn(DoGoogleSignIn event) async* {
    String status = await LoginController().signInWithGoogle();
    switch (status) {
      case "success":
        yield GoogleSignInResponse(response: GoogleSignInResponse.SUCCESS);
        break;
      case "failed":
        yield GoogleSignInResponse(response: GoogleSignInResponse.FAILED);
        break;
      default:
        yield GoogleSignInResponse(response: GoogleSignInResponse.CANCELLED);
    }
  }

  Stream<LoginStates> _doFacebookSignIn(DoFacebookSignIn event) async* {
    String status = await LoginController().signInWithFacebook();
    switch (status) {
      case "success":
        yield FacebookSignInResponse(response: FacebookSignInResponse.SUCCESS);
        break;
      case "failed":
        yield FacebookSignInResponse(response: FacebookSignInResponse.FAILED);
        break;
      default:
        yield FacebookSignInResponse(
            response: FacebookSignInResponse.CANCELLED);
    }
  }
}
