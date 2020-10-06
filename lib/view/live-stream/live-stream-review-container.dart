import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/model/presenter.dart';

import '../../localization.dart';

class LiveStreamReviewContainer extends StatelessWidget {
  final Presenter presenter;
  final bool isFollowed;

  LiveStreamReviewContainer(this.presenter, this.isFollowed);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            BlocProvider.of<FollowBloc>(context)
                                .add(ChangeFollowStatus(presenter.id));
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
                            BlocProvider.of<FollowBloc>(context)
                                .add(ChangeFollowStatus(presenter.id));
                          },
                          child: isFollowed
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
              SizedBox(
                height: 31,
              ),
              Text("Start your review ",
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.30000001192092896,
                  )),
              SizedBox(
                height: 8,
              ),
              ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(bottom: 17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Video quality",
                                style: TextStyle(
                                  color: Color(0xff555555),
                                  fontSize: 13,

                                )
                            ),
                            RatingBar(
                              initialRating: 0,
                              minRating: 1,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.5),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color(0xFFf9d572),
                                size: 14,
                              ),
                              // onRatingUpdate:
                              //     (rating) {
                              //   print(rating);
                              // },
                            ),
                          ],
                        ),
                      )),
              SizedBox(
                height: 14,
              ),
              Text("Your feedback",
                  style: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 13,
                  )),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Color(0xff555555),
                    fontSize: 13,
                  ),
                  hintText: 'Anything you want to say?',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              )






            ]),
      ),
    );
  }
}
