import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/customer-profile/edit-customer-profile.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      height: 300,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                color: Colors.lightBlue,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text("${customerDetails.name}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      NumberFormat().format(20),
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('following'),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                  height: 30,
                ),
                Spacer(
                  flex: 1,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      NumberFormat().format(2),
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('orders').toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  width: 1,
                  color: Colors.grey,
                  height: 30,
                ),
                Spacer(
                  flex: 1,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      NumberFormat().format(0),
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('returns').toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: OutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditCustomerProfilePage()),
                );
              },
              child: Text(
                AppLocalizations.of(context).translate('edit-profile'),
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
