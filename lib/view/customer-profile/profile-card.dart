import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/presenter-message-events.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/bloc/unreadmessage-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/customer.dart';
import 'package:tienda/view/customer-profile/chat-history.dart';
import 'package:tienda/view/customer-profile/edit-customer-profile.dart';
import 'package:tienda/view/customer-profile/following-list.dart';

class CustomerProfileCard extends StatefulWidget {
  final Customer customerDetails;

  CustomerProfileCard(this.customerDetails);

  @override
  _CustomerProfileCardState createState() => _CustomerProfileCardState();
}

class _CustomerProfileCardState extends State<CustomerProfileCard> {
  RealTimeController realTimeController = new RealTimeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    realTimeController.unReadMessage.listen((value) {
      Logger().d("UNREAD LISTNER CALLED");
      if (value != null) {
        BlocProvider.of<UnreadMessageHydratedBloc>(context)
            .add(MessageReceivedEvent(value));
      }
    });
  }

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
              widget.customerDetails.membershipType == "premium"
                  ? IconButton(onPressed: () {
                      RealTimeController().getAllPresenterChats();

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => BlocProvider(
                      //               create: (BuildContext context) =>
                      //                   UnreadMessageHydratedBloc(),
                      //               child: ChatHistory(),
                      //             )));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatHistory()));
                    }, icon: BlocBuilder<UnreadMessageHydratedBloc,
                      PresenterMessageStates>(builder: (context, messageState) {
                      if (messageState is MessageReceivedSuccess) {
                        int count = 0;

                        for (final messageItem in messageState.unReadMessages) {
                          count = count + messageItem.messages.length;
                        }

                        return Badge(
                          badgeContent: Text(
                            count.toString(),
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          ),
                          showBadge: count == 0 ? false : true,
                          child: Icon(
                            Icons.comment,
                            size: 20,
                            color: Colors.grey,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }))
                  : Container(),
              IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EdiCustomerProfilePage(widget.customerDetails)));
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
          widget.customerDetails.profilePicture == null
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
                      "${GlobalConfiguration().getString("imageURL")}/${widget.customerDetails.profilePicture}")),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text("${widget.customerDetails.fullName}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                )),
          ),
          widget.customerDetails.membershipType == "premium"
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
                      widget.customerDetails.points.toString(),
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
                    if (widget.customerDetails.followedPresenters != null)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FollowingList(
                                widget.customerDetails.followedPresenters)),
                      );
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.customerDetails.following.toString(),
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
