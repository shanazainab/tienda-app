import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
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
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(
                        "${GlobalConfiguration().getString("imageURL")}/${widget.presenter.profilePicture}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(widget.presenter.name),
                  )
                ],
              ),
              BlocBuilder<FollowBloc, FollowStates>(
                  cubit: followBloc,
                  builder: (context, substate) {
                    if (substate is ChangeFollowStatusSuccess)
                      return OutlineButton(
                        color: Colors.black,
                        borderSide: BorderSide(
                            color: Colors.black
                        ),
                        onPressed: () {
                          followBloc
                              .add(ChangeFollowStatus(widget.presenter.id));
                        },
                        child: substate.isFollowing
                            ? Row(
                              children: [
                                Text("Following",style: TextStyle(
                                ),),
                                Icon(Icons.check,
                                size: 14,)
                              ],
                            )
                            : Text(AppLocalizations.of(context)
                                .translate("follow")),
                      );
                    return OutlineButton(
                      color: Colors.black,
                      borderSide: BorderSide(
                        color: Colors.black
                      ),
                      onPressed: () {
                        followBloc.add(ChangeFollowStatus(widget.presenter.id));
                      },
                      child: widget.presenter.isFollowed
                          ? Row(
                        children: [
                          Text("Following",style: TextStyle(
                          ),),
                          Icon(Icons.check,
                            size: 14,)
                        ],
                      )
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
