
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/model/live-response.dart';
import 'package:tienda/model/presenter.dart';

import '../../localization.dart';

class ThankYouNote extends StatelessWidget {
  const ThankYouNote({
    Key key,
    @required this.presenter,
    @required this.liveResponse,

  }) : super(key: key);

  final Presenter presenter;
  final LiveResponse liveResponse;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(
                "${GlobalConfiguration().getString("imageURL")}/${presenter.profilePicture}"),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Center(
          child: Text("Thank you for watching.",
              style: TextStyle(
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ),
        Center(
          child: Text(presenter.name,
              style: TextStyle(
                color: Color(0xff555555),
                fontSize: 13,
              )),
        ),
        SizedBox(
          height: 19,
        ),
        Center(
          child: ButtonTheme(
              height: 32,
              child: BlocBuilder<FollowBloc, FollowStates>(
                  builder: (context, followState) {
                    if (followState is ChangeFollowStatusSuccess) {
                      return RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(3))),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        color: Color(0xffeef2f3),
                        onPressed: () {
                          BlocProvider.of<FollowBloc>(context).add(
                              ChangeFollowStatus(presenter.id));
                        },
                        child: followState.isFollowing
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Following".toUpperCase(),
                              style: TextStyle(
                                  color: Color(0xff282828),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.check,
                              color: Color(0xff282828),
                              size: 12,
                            )
                          ],
                        )
                            : Text(
                          AppLocalizations.of(context)
                              .translate("follow")
                              .toUpperCase(),
                          style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    } else
                      return RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(3))),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 4, bottom: 4),
                        color: Color(0xffeef2f3),
                        onPressed: () {
                          BlocProvider.of<FollowBloc>(context).add(
                              ChangeFollowStatus(presenter.id));
                        },
                        child: liveResponse.isFollowed
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Following".toUpperCase(),
                              style: TextStyle(
                                  color: Color(0xff282828),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.check,
                              color: Color(0xff282828),
                              size: 12,
                            )
                          ],
                        )
                            : Text(
                          AppLocalizations.of(context)
                              .translate("follow")
                              .toUpperCase(),
                          style: TextStyle(
                              color: Color(0xff282828),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                  })),
        ),
      ],
    );
  }
}