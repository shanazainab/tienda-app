import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/customer-profile-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/console-logger.dart';
import 'package:tienda/view/address/saved-address-page.dart';
import 'package:tienda/view/customer-profile/login-bar.dart';
import 'package:tienda/view/customer-profile/profile-card.dart';
import 'package:tienda/view/customer-profile/refer-and-earn.dart';
import 'package:tienda/view/home/home-page.dart';
import 'package:tienda/view/order/orders-main-page.dart';
import 'package:tienda/view/returns/returns-page.dart';
import 'package:tienda/view/wishlist/wishlist-page.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final StartupBloc startupBloc = new StartupBloc();

  final CustomerProfileBloc profileBloc = new CustomerProfileBloc();

  static const platform = const MethodChannel('tienda.dev/zendesk');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startupBloc.add(CheckLogInStatus());
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

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
                    _buildMenuList(appLanguage, state)
                  ],
                ));
              })),
    );
  }

  _buildMenuList(appLanguage, state) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
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
              "Orders",
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
              "Returns",
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
              "Wishlist",
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
                Icon(Icons.location_on),
              ],
            ),
            title: Text("Address"),
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
            title: Text("Payments"),
            onTap: () {},
          ),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16),
              child: Text("EXPLORE"),
            ),
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.credit_card),
              ],
            ),
            title: Text("Refer & Earn"),
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
            title: Text("Memberships"),
            onTap: () {},
          ),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16),
              child: Text("SETTINGS"),
            ),
          ),
          ListTile(
            title: Text("Country"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Language"),
            trailing: appLanguage.appLocal == Locale('en')
                ? Text("English")
                : Text("العربية"),
            onTap: () {
              appLanguage.changeLanguage(appLanguage.appLocal == Locale('en')
                  ? Locale('ar')
                  : Locale('en'));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16),
                child: Text("REACH OUT TO US"),
              ),
            ),
          ),
          ListTile(
            title: Text("Call"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Chat To Us"),
            onTap: () {
              handleChat();
            },
          ),
          SizedBox(
            height: 20,
          ),
          state is LogInStatusResponse && state.isLoggedIn
              ? Center(
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.signOutAlt,
                            color: Colors.grey[200],
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      handleLogout(context);
                    },
                  ),
                )
              : Container(),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  void handleLogout(context) {
    BlocProvider.of<LoginBloc>(context).add(Logout());
  }

  void handleLogin(context) {
    Navigator.pushNamed(context, '/loginMainPage');
  }

  void handleChat() {
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    String result;
    try {
      result = await platform.invokeMethod('getChat');
    } on PlatformException catch (e) {
      result = "Platform Method Error: '${e.message}'.";
    }

    new ConsoleLogger().printResponse("******$result");
  }
}
