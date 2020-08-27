import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/localization.dart';
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

  FollowBloc followBloc = new FollowBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFollowing = widget.isFollowed;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[200],
          backgroundImage: NetworkImage(
              "${GlobalConfiguration().getString("imageURL")}/${widget.presenter.profilePicture}"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.presenter.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 2,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("live")
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      StreamBuilder<String>(
                          stream: new RealTimeController().viewCountStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  snapshot.data != null ? snapshot.data : "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          })
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                height: 20,
                width: 75,
                child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        isFollowing = !isFollowing;
                      });
                      followBloc.add(ChangeFollowStatus(widget.presenter.id));
                    },
                    padding: EdgeInsets.only(top:2,bottom: 2,left: 4,right: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        isFollowing
                            ? Icon(
                                Icons.check,
                                size: 12,
                              )
                            : Container()
                      ],
                    )),
              )
            ],
          ),
        ),
      ],
    );
  }
}
