import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-country.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/preference-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/preference-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/preference-states.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/controller/customer-care-controller.dart';
import 'package:tienda/view/address/saved-address-page.dart';
import 'package:tienda/view/customer-profile/bottom-container.dart';
import 'package:tienda/view/customer-profile/login-bar.dart';
import 'package:tienda/view/explore/help.dart';
import 'package:tienda/view/explore/memberships.dart';
import 'package:tienda/view/customer-profile/profile-card.dart';
import 'package:tienda/view/explore/refer-and-earn.dart';
import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/order/orders-main-page.dart';
import 'package:tienda/view/returns/returns-page.dart';
import 'package:tienda/view/startup/country-list-card.dart';
import 'package:tienda/view/wishlist/wishlist-main-page.dart';

import '../../localization.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final StartupBloc startupBloc = new StartupBloc();

  final CustomerProfileBloc profileBloc = new CustomerProfileBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startupBloc.add(CheckLogInStatus());
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var appCountry = Provider.of<AppCountry>(context);

    return BlocProvider(
      create: (BuildContext context) => profileBloc,
      child: MultiBlocListener(
          listeners: [
            BlocListener<LoginBloc, LoginStates>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
            BlocListener<StartupBloc, StartupStates>(
              bloc: startupBloc,
              listener: (context, state) {
                if (state is LogInStatusResponse && state.isLoggedIn) {
                  profileBloc.add(FetchCustomerProfile());
                }
              },
            ),
          ],
          child: BlocBuilder<StartupBloc, StartupStates>(
              bloc: startupBloc,
              builder: (context, state) {
                return Scaffold(
                    body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    state is LogInStatusResponse && !state.isLoggedIn
                        ? CustomerLoginMenu()
                        : BlocBuilder<CustomerProfileBloc,
                            CustomerProfileStates>(builder: (context, state) {
                            if (state is LoadCustomerProfileSuccess)
                              return CustomerProfileCard(state.customerDetails);
                            else
                              return Container();
                          }),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          state is LogInStatusResponse && state.isLoggedIn
                              ? _buildLoggedInUserMenus(appLanguage, state)
                              : Container(),
                          _buildMenuList(appLanguage, state, appCountry)
                        ],
                      ),
                    )
                  ],
                ));
              })),
    );
  }

  _buildMenuList(appLanguage, state, AppCountry appCountry) {
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
                size: 18,
              ),
            ],
          ),
          trailing: Container(
            width: 55,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  "${GlobalConfiguration().getString("baseURL")}${appCountry.chosenCountry.thumbnail}",
                  width: 25,
                  height: 15,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 0.0),
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
              FaIcon(
                FontAwesomeIcons.flag,
                size: 18,
              ),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('language'),
          ),
          trailing: appLanguage.appLocal != Locale('en')
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("English"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.phone,
                size: 18,
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
              Icon(Icons.message),
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
              Icon(Icons.message),
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
        BottomContainer(state is LogInStatusResponse && state.isLoggedIn)
      ],
    );
  }

  _buildLoggedInUserMenus(AppLanguage appLanguage, StartupStates state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.format_list_bulleted,
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
              MaterialPageRoute(builder: (context) => OrdersMainPage()),
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
              Icon(Icons.sync),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('returns'),
            style: TextStyle(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReturnsPage()),
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
              Icon(Icons.bookmark),
            ],
          ),
          title: Text(
            AppLocalizations.of(context).translate('wishlist'),
            style: TextStyle(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishListMainPage()),
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
              Icon(Icons.location_on),
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
              MaterialPageRoute(builder: (context) => SavedAddressPage()),
            );
          },
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.credit_card),
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
              Icon(Icons.credit_card),
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
              Icon(Icons.credit_card),
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
