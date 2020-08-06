import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/customer-profile/edit-customer-profile.dart';
import 'package:tienda/view/customer-profile/following-list.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Container(
      height: 260,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EdiCustomerProfilePage(customerDetails)));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    AppLocalizations.of(context).translate('edit-profile'),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          customerDetails.profileImage == null?CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
          ):
          CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xfff2f2e4),
              backgroundImage: NetworkImage(
                  "${GlobalConfiguration().getString("baseURL")}/${customerDetails.profileImage}")),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(
                  flex: 2,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "2000",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('tienda-points'),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey[200],
                ),
                Spacer(
                  flex: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FollowingList()),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        NumberFormat().format(0),
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                      Text(
                        AppLocalizations.of(context).translate('following'),
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      )
                    ],
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
