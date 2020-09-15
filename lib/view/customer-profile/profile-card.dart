import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/customer-profile/chat-history.dart';
import 'package:tienda/view/customer-profile/edit-customer-profile.dart';
import 'package:tienda/view/customer-profile/following-list.dart';

class CustomerProfileCard extends StatelessWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Container(
      height: 270,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              customerDetails.membershipType == "premium"
                  ? IconButton(
                      onPressed: () {
                        RealTimeController().getAllPresenterChats();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (BuildContext context) =>
                                          UnreadMessageHydratedBloc(),
                                      child: ChatHistory(),
                                    )));
                      },
                      icon: Icon(
                        Icons.comment,
                        size: 20,
                        color: Colors.grey,
                      ),
                    )
                  : Container(),
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EdiCustomerProfilePage(customerDetails)));
                },
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          customerDetails.profilePicture == null
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: Colors.lightBlue,
                  ),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xfff2f2e4),
                  backgroundImage: CachedNetworkImageProvider(
                      "${GlobalConfiguration().getString("imageURL")}/${customerDetails.profilePicture}")),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text("${customerDetails.fullName}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                )),
          ),
          customerDetails.membershipType == "premium"
              ? Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4, bottom: 4),
                    child: Text(
                      "PREMIUM",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                )
              : Container(),
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
                      customerDetails.points.toString(),
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

                    if(customerDetails.followedPresenters != null)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FollowingList(
                              customerDetails.followedPresenters)),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        customerDetails.following.toString(),
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
