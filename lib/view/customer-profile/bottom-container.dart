import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tienda/bloc/events/login-events.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/localization.dart';

class BottomContainer extends StatelessWidget {
  final bool isLoggedIn;

  BottomContainer(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
         isLoggedIn
              ? Center(
            child: FlatButton(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      MdiIcons.login,
                      size: 18,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        AppLocalizations.of(context).translate('logout'),
                        style: TextStyle(color: Colors.grey),
                      ),
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
          Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.grey,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Colors.grey,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FontAwesomeIcons.twitter,
                        color: Colors.grey,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FontAwesomeIcons.linkedin,
                        color: Colors.grey,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 2,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('terms-of-use'),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('terms-of-sale'),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('privacy-policy'),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 2,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('warranty-policy'),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('return-policy'),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleLogout(context) {
    BlocProvider.of<LoginBloc>(context).add(Logout());
  }
}
