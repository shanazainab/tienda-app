import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/widgets/custom-app-bar.dart';

class Memberships extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
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
            color: Colors.grey,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 24,
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (_, index) =>  Card(
              color: Colors.grey,
              child: Container(
              ),
            ),
            itemCount: 8,
          )
        ],
      ) ,
    );
  }
}
