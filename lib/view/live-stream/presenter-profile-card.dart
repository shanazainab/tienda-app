import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/model/presenter.dart';

class PresenterProfileCard extends StatefulWidget {
  final Presenter presenter;

  final bool isFollowed;

  PresenterProfileCard(this.presenter, this.isFollowed);

  @override
  _PresenterProfileCardState createState() => _PresenterProfileCardState();
}

class _PresenterProfileCardState extends State<PresenterProfileCard> {
  bool isFollowing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollowing = widget.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage: CachedNetworkImageProvider(
                  "${GlobalConfiguration().getString("imageURL")}/media/${widget.presenter.profilePicture}"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.presenter.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  BlocBuilder<FollowBloc, FollowStates>(
                      builder: (context, state) {
                    if (state is ChangeFollowStatusSuccess) if (state
                            .followersCount ==
                        null)
                      return Text(
                        "${widget.presenter.followers} subscribers",
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 13,
                        ),
                      );
                    else
                      return Text(
                        "${state.followersCount} subscribers",
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 13,
                        ),
                      );
                    else
                      return Text(
                        "${widget.presenter.followers} subscribers",
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 13,
                        ),
                      );
                  })
                ],
              ),
            ),
          ],
        ),
        BlocBuilder<FollowBloc, FollowStates>(builder: (context, followState) {
          if (followState is ChangeFollowStatusSuccess) {
            return GestureDetector(
                onTap: () {
                  BlocProvider.of<FollowBloc>(context)
                      .add(ChangeFollowStatus(widget.presenter.id));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isFollowing ? 'FOLLOWING' : 'FOLLOW',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF398994),
                      ),
                    ),
                    isFollowing
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: Color(0xFF398994),
                          )
                        : Container()
                  ],
                ));
          } else
            return GestureDetector(
                onTap: () {
                  BlocProvider.of<FollowBloc>(context)
                      .add(ChangeFollowStatus(widget.presenter.id));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isFollowing ? 'FOLLOWING' : 'FOLLOW',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF398994),
                      ),
                    ),
                    isFollowing
                        ? Icon(
                            Icons.check,
                            size: 12,
                            color: Color(0xFF398994),
                          )
                        : Container()
                  ],
                ));
        })
      ],
    );
  }
}
