import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReferAndEarn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            title: Text("Refer & Earn"),
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
              Invite(),
              Reward(),
              FAQ(),
            ],
          ),
        ));
  }
}

class Invite extends StatelessWidget {
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
                        "HDJ8340WT",
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
      uriPrefix: 'https://beuniquegroup.page.link/amTC',

      link: Uri.parse('https://tienda.ae/'),
      androidParameters: AndroidParameters(
        packageName: 'com.beuniquegroup.tienda',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.beuniquegroup.tienda',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    final RenderBox box = context.findRenderObject();
    Share.share("$dynamicUrl",
        subject: "It doesn't get better than this! Download Tienda App Now !!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class Reward extends StatelessWidget {
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
              children: <Widget>[Text("Your Referral Earnings"), Text("0 AED")],
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

class FAQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
