import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/login/login-main-page.dart';

class CustomerLoginMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text(
              AppLocalizations.of(context).translate('profile-menu-caption'),
              style: TextStyle(fontSize: 20),
            ),
            Text(
              AppLocalizations.of(context)
                  .translate('profile-menu-sub-caption'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginMainPage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.lightBlue,
                            child: Icon(Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('login'),
                        )
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginMainPage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.lightBlue,
                            child: Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('sign-up'),
                        )
                      ],
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
