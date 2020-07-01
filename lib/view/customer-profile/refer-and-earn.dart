import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ReferAndEarn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
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

  void handleReferralShare(context) {
    final RenderBox box = context.findRenderObject();
    Share.share("code",
        subject: "referral",
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
