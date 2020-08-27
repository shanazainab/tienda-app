import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class Memberships extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: CustomAppBar(
          showLogo: false,
          showCart: false,
          showSearch: false,
          showWishList: false,
          title: AppLocalizations.of(context).translate("memberships"),
        ),
      ),
      body:ListView(
        padding: EdgeInsets.all(24),
        shrinkWrap: true,
        children: <Widget>[
          ///Main card
          Card(
            color: Colors.grey[200],
            child: Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Connect with presenters'),
                    ),
                    ListTile(
                      title: Text('Early access to deals'),
                    ),
                    ListTile(
                      title:  Text('Faster delivery')
                    ),

                  ],
                ),
              ),
              width: MediaQuery.of(context).size.width - 24,
            ),
          ),
          RaisedButton(
            onPressed: (){

            },
            child: Text("GO PREMIUM"),
          )
        ],
      ) ,
    );
  }
}
