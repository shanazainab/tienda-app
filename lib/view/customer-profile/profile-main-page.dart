import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-country.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/address-bloc.dart';
import 'package:tienda/bloc/events/address-events.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/order-events.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/orders-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/controller/customer-care-controller.dart';
import 'package:tienda/view/address/saved-address-page.dart';
import 'package:tienda/view/customer-profile/bottom-container.dart';
import 'package:tienda/view/customer-profile/customer-login-menu.dart';
import 'package:tienda/view/explore/help.dart';
import 'package:tienda/view/explore/memberships.dart';
import 'package:tienda/view/customer-profile/profile-card.dart';
import 'package:tienda/view/explore/refer-and-earn.dart';
import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/order/orders-main-page.dart';
import 'package:tienda/view/startup/country-list-card.dart';
import 'package:tienda/view/widgets/network-state-wrapper.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

import '../../localization.dart';

class CustomerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var appCountry = Provider.of<AppCountry>(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginStates>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                BlocProvider.of<LoginBloc>(context).add(CheckLoginStatus());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
              if (state is LoggedInUser) {
                BlocProvider.of<CustomerProfileBloc>(context)
                    .add(FetchCustomerProfile());
              }
            },
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginStates>(builder: (context, state) {
          if (state is GuestUser)
            return Scaffold(
                body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CustomerLoginMenu(),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        state is LoggedInUser
                            ? _buildLoggedInUserMenus(appLanguage, context)
                            : Container(),
                        _buildMenuList(appLanguage, state, appCountry, context),
                        LogoutContainer(state is LoggedInUser)
                      ],
                    ),
                  ),
                )
              ],
            ));
          else {
            return NetworkStateWrapper(
              opacity: 0,

              ///Don show overlap
              networkState: (value) {
                if (value == ConnectivityResult.none) {
                  BlocProvider.of<CustomerProfileBloc>(context)
                      .add(OfflineLoadCustomerData());
                }
              },
              child: BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
                  builder: (context, substate) {
                if (substate is LoadCustomerProfileSuccess)
                  return Scaffold(
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomerProfileCard(substate.customerDetails),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListView(
                              padding: EdgeInsets.all(0),
                              children: <Widget>[
                                state is LoggedInUser
                                    ? _buildLoggedInUserMenus(
                                        appLanguage, context)
                                    : Container(),
                                _buildMenuList(
                                    appLanguage, state, appCountry, context),
                                LogoutContainer(state is LoggedInUser)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                if (substate is OfflineLoadCustomerDataSuccess)
                  return Scaffold(
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomerProfileCard(substate.customerDetails),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListView(
                              padding: EdgeInsets.all(0),
                              children: <Widget>[
                                state is LoggedInUser
                                    ? _buildLoggedInUserMenus(
                                        appLanguage, context)
                                    : Container(),
                                _buildMenuList(
                                    appLanguage, state, appCountry, context),
                                LogoutContainer(state is LoggedInUser)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                else
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
              }),
            );

//            return Scaffold(
//                body: Column(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    NetworkStateWrapper(
//                      opacity: 0,
//
//                      ///Don show overlap
//                      networkState: (value) {
//                        if (value == ConnectivityResult.none) {
//                          BlocProvider.of<CustomerProfileBloc>(context)
//                              .add(OfflineLoadCustomerData());
//                        }
//                      },
//                      child:
//                      BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
//                          builder: (context, state) {
//                            if (state is LoadCustomerProfileSuccess)
//                              return Column(
//                                children: [
//                                  CustomerProfileCard(state.customerDetails),
//                                  Expanded(
//                                    child: Container(
//                                      color: Colors.white,
//                                      child: ListView(
//                                        padding: EdgeInsets.all(0),
//                                        children: <Widget>[
//                                          state is LoggedInUser
//                                              ? _buildLoggedInUserMenus(appLanguage, context)
//                                              : Container(),
//                                          _buildMenuList(appLanguage, state, appCountry, context),
//                                          LogoutContainer(state is LoggedInUser)
//                                        ],
//                                      ),
//                                    ),
//                                  )
//                                ],
//                              );
//                            if (state is OfflineLoadCustomerDataSuccess)
//                              return Column(
//                                children: [
//                                  CustomerProfileCard(state.customerDetails),
//                                  Expanded(
//                                    child: Container(
//                                      color: Colors.white,
//                                      child: ListView(
//                                        padding: EdgeInsets.all(0),
//                                        children: <Widget>[
//                                          state is LoggedInUser
//                                              ? _buildLoggedInUserMenus(appLanguage, context)
//                                              : Container(),
//                                          _buildMenuList(appLanguage, state, appCountry, context),
//                                          LogoutContainer(state is LoggedInUser)
//                                        ],
//                                      ),
//                                    ),
//                                  )
//                                ],
//                              );
//                            else
//                              return Container(
//                                height: 260,
//                              );
//                          }),
//                    ),
//                    Expanded(
//                      child: Container(
//                        color: Colors.white,
//                        child: ListView(
//                          padding: EdgeInsets.all(0),
//                          children: <Widget>[
//                            state is LoggedInUser
//                                ? _buildLoggedInUserMenus(appLanguage, context)
//                                : Container(),
//                            _buildMenuList(appLanguage, state, appCountry, context),
//                            LogoutContainer(state is LoggedInUser)
//                          ],
//                        ),
//                      ),
//                    )
//                  ],
//                ));
          }
        }));
  }

  _buildMenuList(appLanguage, state, AppCountry appCountry, context) {
    bool isEnglish = appLanguage.appLocal == Locale('en');
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Text(
              AppLocalizations.of(context).translate('settings'),
            ),
          ),
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.globe,
                size: 14,
              ),
            ],
          ),
          trailing: Container(
            width: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.network(
                    "${GlobalConfiguration().getString("imageURL")}${appCountry.chosenCountry.thumbnail}",
                    width: 22,
                    height: 12,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          title: Text(
            AppLocalizations.of(context).translate('country'),
          ),
          onTap: () {
            ///change country

            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return BlocProvider<PreferenceBloc>(
                    create: (context) =>
                        PreferenceBloc()..add(FetchCountryList()),
                    child: BlocBuilder<PreferenceBloc, PreferenceStates>(
                        builder: (context, state) {
                      if (state is LoadCountryListSuccess)
                        return CountryListCard(
                          countries: state.countries,
                          function: (selectedCountry) {
                            appCountry.changeCountry(selectedCountry);
                            Navigator.pop(context);
                          },
                        );
                      else
                        return Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ));
                    }),
                  );
                });
          },
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(FontAwesomeIcons.flag, size: 14),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('language'),
          ),
          trailing: appLanguage.appLocal != Locale('en')
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("English"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("العربية"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    )
                  ],
                ),
          onTap: () {
            appLanguage.changeLanguage(appLanguage.appLocal == Locale('en')
                ? Locale('ar')
                : Locale('en'));
          },
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Text(
              AppLocalizations.of(context).translate('reach-out-to-us'),
            ),
          ),
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.phone,
                size: 14,
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          title: Text(
            AppLocalizations.of(context).translate('call'),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.message, size: 18),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          title: Text(
            AppLocalizations.of(context).translate('chat-to-us'),
          ),
          onTap: () {
            new CustomerCareController().startChat();
          },
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.message, size: 18),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          title: Text(
            AppLocalizations.of(context).translate('help'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Help()),
            );
          },
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _buildLoggedInUserMenus(AppLanguage appLanguage, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.format_list_bulleted,
                size: 18,
              ),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('orders'),
            style: TextStyle(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (BuildContext context) =>
                          OrdersBloc()..add(LoadOrders()),
                      child: OrdersMainPage())),
            );
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.heart,
                size: 18,
              ),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('wishlist'),
            style: TextStyle(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishListPage()),
            );
          },
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 18,
              ),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('address'),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (context) => AddressBloc()..add(LoadSavedAddress()),
                  child: SavedAddressPage(),
                );
              }),
            );
          },
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.credit_card,
                size: 18,
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          title: Text(
            AppLocalizations.of(context).translate('payment'),
          ),
          onTap: () {},
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16),
            child: Text(
              AppLocalizations.of(context).translate('explore'),
            ),
          ),
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.star, size: 18),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('refer-and-earn'),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReferAndEarn()),
            );
          },
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.apps, size: 18),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          title: Text(
            AppLocalizations.of(context).translate('memberships'),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Memberships()),
            );
          },
        )
      ],
    );
  }
}
