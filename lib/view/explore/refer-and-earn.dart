import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:tienda/bloc/customer-profile-bloc.dart';
import 'package:tienda/bloc/states/customer-profile-states.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/explore/faq.dart';

class ReferAndEarn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerProfileBloc, CustomerProfileStates>(
        builder: (context, state) {
      if (state is LoadCustomerProfileSuccess)
        return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                title: Text("Refer & Earn".toUpperCase()),
                bottom: TabBar(
                  unselectedLabelColor: Colors.grey[200],
                  indicatorColor: Colors.lightBlue,
                  labelColor: Colors.lightBlue,
                  tabs: [
                    Tab(
                      text: "INVITE",
                    ),
                    Tab(text: "REWARD"),
                    Tab(text: "FAQs"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Invite(state.customerDetails),
                  Reward(state.customerDetails),
                  FAQ(),
                ],
              ),
            ));
      else
        return Container();
    });
  }
}

class Invite extends StatelessWidget {
  final Customer customer;

  Invite(this.customer);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 270,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Image Banner"),
                        Text("Invite - Refer - Earn"),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.grey[200])),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        customer.referral,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 398,
            child: Center(
                child: ButtonTheme(
              minWidth: 200,
              child: RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () {
                    handleReferralShare(context);
                  },
                  child: Text(
                    "SHARE",
                    style: TextStyle(color: Colors.white),
                  )),
            )),
          )
        ],
      ),
    );
  }

  Future<void> handleReferralShare(context) async {
    ///create dynamic link for referral
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://l.tienda.ae/l',
      link: Uri.parse('https://tienda.ae/referral/${customer.referral}'),
      androidParameters: AndroidParameters(
        packageName: 'com.tienda.liveshop',
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      iosParameters: IosParameters(
        bundleId: 'com.beuniquegroup.tienda',
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    final RenderBox box = context.findRenderObject();
    Share.share("$shortUrl",
        subject:
            "It doesn't get better than this! Use my code ${customer.referral} to download Tienda App Now !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class Reward extends StatelessWidget {
  final Customer customer;

  Reward(this.customer);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Your Referral Earnings"),
                Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                    child: Text(
                      "TIENDA POINTS: 1000",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("People You have Signed Up"), Text("0")],
            )
          ],
        ),
      ),
    );
  }
}
