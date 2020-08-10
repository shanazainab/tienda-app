import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/events/follow-events.dart';
import 'package:tienda/bloc/follow-bloc.dart';
import 'package:tienda/bloc/states/follow-states.dart';
import 'package:tienda/model/presenter.dart';

import '../../localization.dart';

class PresenterInfoContainer extends StatefulWidget {
  final Presenter presenter;

  PresenterInfoContainer(this.presenter);

  @override
  _PresenterInfoContainerState createState() => _PresenterInfoContainerState();
}

class _PresenterInfoContainerState extends State<PresenterInfoContainer> {
  FollowBloc followBloc = new FollowBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(widget.presenter.name),
                  )
                ],
              ),
              BlocBuilder<FollowBloc, FollowStates>(
                  bloc: followBloc,
                  builder: (context, substate) {
                    if (substate is ChangeFollowStatusSuccess)
                      return RaisedButton(
                        onPressed: () {
                          followBloc
                              .add(ChangeFollowStatus(widget.presenter.id));
                        },
                        color: Colors.blue,
                        child: substate.isFollowing
                            ? Row(
                              children: [
                                Text("Following",style: TextStyle(
                                  color: Colors.white
                                ),),
                                Icon(Icons.check,
                                 color: Colors.white,
                                size: 14,)
                              ],
                            )
                            : Text(AppLocalizations.of(context)
                                .translate("follow")),
                      );
                    return RaisedButton(
                      onPressed: () {
                        followBloc.add(ChangeFollowStatus(widget.presenter.id));
                      },
                      color: Colors.blue,
                      child: widget.presenter.isFollowed
                          ? Text("Following")
                          : Text(
                              AppLocalizations.of(context).translate("follow")),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.presenter.bio,
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.justify,
            softWrap: true,
          )
        ],
      ),
    );
  }
}
