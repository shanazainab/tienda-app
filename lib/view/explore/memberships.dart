import 'package:flutter/material.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/customer-profile/payment/premium-payment-page.dart';
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
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 8,
          child: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Connect with presenters',
                  //  style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Early access to deals',
                   // style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Faster delivery',
                  //  style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                  'Zero delivery charge',
                  //style: TextStyle(color: Colors.white),
                )),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      //  side: BorderSide(color: Colors.white)
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PremiumPaymentPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "GO PREMIUM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
