import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda/app-country.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/app-settings.config.dart';
import 'package:tienda/bloc-delegate.dart';
import 'package:tienda/bloc/bottom-nav-bar-bloc.dart';
import 'package:tienda/bloc/cart-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/events/cart-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/loading-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/bloc/wishlist-bloc.dart';
import 'package:tienda/controller/db-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/video-overlays/overlay_handler.dart';
import 'package:tienda/video-overlays/overlay_service.dart';
import 'package:tienda/view/home/page/home-screen.dart';
import 'package:tienda/view/home/page/main-screen.dart';
import 'package:tienda/view/live-stream/page/live-main-page.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/login/otp-verification-page.dart';
import 'package:tienda/view/startup/category-selection-page.dart';
import 'package:tienda/view/startup/country-choose-page.dart';
import 'package:tienda/view/startup/language-preference-page.dart';
import 'package:tienda/view/startup/splash-screen.dart';
import 'package:tienda/view/startup/welcome-screen.dart';
import 'package:tienda/view/widgets/bottom-nav-bar.dart';

import 'bloc/events/bottom-nav-bar-events.dart';
import 'bloc/events/presenter-events.dart';
import 'bloc/presenter-bloc.dart';
import 'controller/real-time-controller.dart';

///Tienda : Video streaming e-commerce app
///Start date : May 17 2020
///Author: Shahana
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Flutter Downloader: To Run background task for product video offline support
  await FlutterDownloader.initialize(debug: true);

  ///Initialize flutter SQLite
  DBController().initializeDB();

  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // sharedPreferences.clear();

  ///Enable Firebase analytics
  FirebaseAnalytics analytics = FirebaseAnalytics();

  ///Enable firebase crash analytics
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  //FlutterError.onError = Crashlytics.instance.recordFlutterError;

  ///To track bloc pattern states and transitions
  Bloc.observer = TrackBlocDelegate();

  ///Bloc persistence with hydrated bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  RealTimeController().initialize();

  ///load global app settings
  GlobalConfiguration().loadFromMap(appSettingsDev);

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  AppCountry appCountry = AppCountry();
  await appCountry.fetchCountry();

  FirebaseAnalytics().logAppOpen();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<StartupBloc>(
        lazy: false,
        create: (BuildContext context) => StartupBloc()..add(AppStarted()),
      ),
      BlocProvider<PreferenceBloc>(
        create: (BuildContext context) => PreferenceBloc(),
      ),
      BlocProvider<LoginBloc>(
        lazy: false,
        create: (BuildContext context) => LoginBloc()..add(CheckLoginStatus()),
      ),
      BlocProvider<WishListBloc>(
        create: (BuildContext context) => WishListBloc(),
      ),
      BlocProvider<CustomerProfileBloc>(
        create: (BuildContext context) =>
            CustomerProfileBloc()..add(FetchCustomerProfile()),
      ),
      BlocProvider<LoadingBloc>(
          create: (BuildContext context) => LoadingBloc()),
      BlocProvider<CartBloc>(
        create: (BuildContext context) => CartBloc()..add(FetchCartData()),
      ),
      BlocProvider<PresenterBloc>(
        lazy: false,
        create: (BuildContext context) =>
            PresenterBloc()..add(LoadPopularPresenters()),
      ),
      BlocProvider<BottomNavBarBloc>(
          create: (BuildContext context) => BottomNavBarBloc()),
      BlocProvider<UnreadMessageHydratedBloc>(
          create: (BuildContext context) => UnreadMessageHydratedBloc()),
    ],
    child: App(
      appCountry: appCountry,
      appLanguage: appLanguage,
    ),
  ));
}

class App extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final AppLanguage appLanguage;

  final AppCountry appCountry;

  App({this.appLanguage, this.appCountry});

  ///change font family based on language locale

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appLanguage),
          ChangeNotifierProvider(create: (_) => appCountry),
          ChangeNotifierProvider<OverlayHandlerProvider>(
            create: (_) => OverlayHandlerProvider(),
          )
        ],
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            builder: (context, child) {
              return ScrollConfiguration(
                  behavior: ScrollWithNoGlowBehaviour(), child: child);
            },

            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              ///To track PageRoute transitions
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            locale: model.appLocal,
            supportedLocales: [
              const Locale('en', ''),
              const Locale('ar', ''),
            ],
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/shopLiveStream':
                  return PageTransition(
                      child: LiveMainPage(),
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.downToUp);
                  break;

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
                      child: LoginMainPage(),
                      type: PageTransitionType.downToUp);
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
                fontFamily: appLanguage.appLocal != Locale('en')
                    ? 'Cairo'
                    : 'SFProDisplay',
                textTheme: TextTheme(
                  headline1: TextStyle(
                    fontSize: 14,
                  ),
                  headline2: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                appBarTheme: AppBarTheme(
                    elevation: 0,
                    brightness: Brightness.light,
                    color: Colors.white,
                    iconTheme: IconThemeData(color: Color(0xff555555)),
                    textTheme:
                        TextTheme(title: TextStyle(color: Color(0xff555555)))),
                accentColor: Color(0xffc30045),
                buttonTheme: ButtonThemeData(
                  buttonColor: Color(0xff50C0A8),
                  padding: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textTheme: ButtonTextTheme.accent,
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        secondary: Colors.white,
                      ),
                )),
            routes: {
              '/homePageData': (context) => HomeScreen(),
            },
            home: Directionality(
              textDirection: appLanguage.appLocal != Locale('en')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: BlocBuilder<StartupBloc, StartupStates>(
                builder: (context, state) {
                  if (state is Initialized) {
                    return SplashScreen();
                  }
                  if (state is PreferenceFlowFetchComplete) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _insertOverlay(context, state.route));

                    switch (state.route) {
                      case '/homePage':
                        return MainScreen();

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
                    return SplashScreen();
                },
              ),
            ),
          );
        }));
  }

  ///Bottom Navigation bar is added as an overlay widget
  ///inorder to support pip mode overlay from live stream or product review video
  void _insertOverlay(BuildContext context, String route) {
    if (route != '/homePage') {
      BlocProvider.of<BottomNavBarBloc>(context)
          .add(ChangeBottomNavBarState(0, true));
    }
    return OverlayService().addBottomNavigationBar(
        context,
        Positioned(
            bottom: 0, left: 16, right: 16, child: BottomNavFloatingBar()),
        true,
        true);
  }
}

///Disable scroll glow
class ScrollWithNoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
