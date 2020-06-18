import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/app-settings.config.dart';
import 'package:tienda/bloc-delegate.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/home/main-page.dart';
import 'package:tienda/view/startup/country-choose-page.dart';
import 'package:tienda/view/startup/language-preference-page.dart';
import 'package:tienda/view/startup/splash-screen.dart';
import 'package:tienda/view/startup/welcome-screen.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/startup/category-selection-page.dart';
import 'package:tienda/view/login/otp-verification-page.dart';

///Tienda : Video streaming e-commerce app
///Start date : May 17 2020
///Author: Shahana

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();*/

  ///Enable firebase crash analytics
  // Crashlytics.instance.enableInDevMode = true;

  ///To track bloc pattern states and transitions
 // BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  BlocSupervisor.delegate = TrackBlocDelegate();

  ///load global app settings
  GlobalConfiguration().loadFromMap(appSettings);

  ///add firebase crash analytics to entire MaterialApp
  /* runZonedGuarded(() async {
    runApp(
      BlocProvider(
        create: (context) => StartupBloc()..add(StartupEvent.AppStarted),
        child: App(),
      ),
    );
  }, Crashlytics.instance.recordError);*/
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<StartupBloc>(
        create: (context) => StartupBloc()..add(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        create: (BuildContext context) => LoginBloc(),
      ),
    ],
    child: App(
      appLanguage: appLanguage,
    ),
  ));
}

class App extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final AppLanguage appLanguage;

  App({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          /*navigatorObservers: [
        ///Track page transitions with firebase analytics
        FirebaseAnalyticsObserver(analytics: analytics),
      ],*/
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: model.appLocal,

          ///Page transition effects can be added here
          supportedLocales: [
            const Locale('en', ''),
            const Locale('ar', ''),
          ],
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/countryChoosePage':
                return PageTransition(
                    child: CountryChoosePage(),
                    type: PageTransitionType.rightToLeft);
                break;
              case '/languagePreferencePage':
                return PageTransition(
                    child: LanguagePreferencePage(),
                    type: PageTransitionType.rightToLeft);
                break;
              case '/categorySelectionPage':
                return PageTransition(
                    child: CategorySelectionPage(),
                    type: PageTransitionType.rightToLeft);
                break;
              case '/loginMainPage':
                return PageTransition(
                    child: LoginMainPage(), type: PageTransitionType.downToUp);
                break;
              case '/otpVerification':
                return PageTransition(
                    child: OTPVerificationPage(),
                    type: PageTransitionType.downToUp);
                break;

              default:
                return null;
            }
          },

          ///App wide theme
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.grey
              ),
              textTheme: TextTheme(

              )
            ),
              accentColor: Colors.blue,
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textTheme: ButtonTextTheme.primary,
              )),

          ///App startup with bloc pattern architecture with flutter_bloc
          ///Splash screen transition with data fetch on progress

          ///{ "/welcomeScreen":true,
          ///   "/countryChoosePage":false,
          ///   "/languagePreferencePage":false,
          ///   "/categorySelectionPage":false }

          home: BlocBuilder<StartupBloc, StartupStates>(
            builder: (context, state) {
              if (state is Initialized) {
                return SplashScreen();
              }
              if (state is PreferenceFlowFetchComplete) {
                switch (state.route) {
                  case '/homePage':
                    return MainPage();
                    break;
                  case '/welcomeScreen':
                    return WelcomeScreen();
                    break;
                  case '/countryChoosePage':
                    return CountryChoosePage();
                    break;
                  case '/languagePreferencePage':
                    return LanguagePreferencePage();
                    break;
                  case '/categorySelectionPage':
                    return CategorySelectionPage();
                    break;
                  default:
                    return WelcomeScreen();
                }
              } else
                return Container();
            },
          ),
        );
      }),
    );
  }
}
