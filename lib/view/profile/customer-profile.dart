import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/events/profile-events.dart';
import 'package:tienda/bloc/events/startup-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/profile-bloc.dart';
import 'package:tienda/bloc/startup-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/profile-states.dart';
import 'package:tienda/bloc/states/startup-states.dart';
import 'package:tienda/view/address/choose-address-page.dart';
import 'package:tienda/view/home/main-page.dart';
import 'package:tienda/view/profile/customer-profile-card.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final StartupBloc startupBloc = new StartupBloc();

  final ProfileBloc profileBloc = new ProfileBloc();

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
                    MaterialPageRoute(builder: (context) => MainPage()),
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
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: <Widget>[
                        state is LogInStatusResponse && !state.isLoggedIn
                            ? ListTile(
                                title: Text("Login"),
                                onTap: () {
                                  handleLogin(context);
                                },
                              )
                            : BlocBuilder<ProfileBloc, ProfileStates>(
                                builder: (context, state) {
                                if (state is LoadCustomerProfileSuccess)
                                  return CustomerProfileCard(
                                      state.customerDetails);
                                else
                                  return Container();
                              }),
                        SizedBox(
                          height: 50,
                        ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseAddressPage()),
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
                          title: Text("Payments"),
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
                            appLanguage.changeLanguage(
                                appLanguage.appLocal == Locale('en')
                                    ? Locale('ar')
                                    : Locale('en'));
                          },
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
                          title: Text("Refer & Earn"),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text("Memberships"),
                          onTap: () {},
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            color: Colors.grey[200],
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16),
                              child: Text("REACH OUT TO US"),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text("WhatsApp Us"),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text("Call"),
                          onTap: () {},
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        state is LogInStatusResponse && state.isLoggedIn
                            ? Center(
                                child: FlatButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FaIcon(FontAwesomeIcons.signOutAlt),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("Logout"),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    handleLogout(context);
                                  },
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  void handleLogout(context) {
    BlocProvider.of<LoginBloc>(context).add(Logout());
  }

  void handleLogin(context) {
    Navigator.pushNamed(context, '/loginMainPage');
  }
}
