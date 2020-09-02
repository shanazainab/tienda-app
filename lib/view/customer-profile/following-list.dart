import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';

class FollowingList extends StatelessWidget {
  final List<Presenter> followedPresenters;

  FollowingList(this.followedPresenters);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text('Following'.toUpperCase()),
        centerTitle: false,
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: followedPresenters.isEmpty
            ? Align(
                alignment: Alignment.center,
                child: Text("You are following none"))
            : Column(
                children: <Widget>[
                  followedPresenters.length > 10
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minHeight: 32,
                                  minWidth: 32,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.grey[200])),
                                isDense: true,
                                fillColor: Colors.grey[200],
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: Colors.grey[200])),
                                focusColor: Colors.grey[200],
                                hintText: 'Search name',
                                hintStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none),
                          ),
                        )
                      : Container(),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: followedPresenters.length,
                      itemBuilder: (BuildContext context, int index) => Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    width: 70,
                                    child: Stack(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PresenterProfilePage(
                                                          followedPresenters[
                                                                  index]
                                                              .id)),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                  "${GlobalConfiguration().getString("imageURL")}/${followedPresenters[index].profilePicture}",
                                                )),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border:
                                                    followedPresenters[index]
                                                            .isLive
                                                        ? Border.all(
                                                            color: Colors
                                                                .lightBlue)
                                                        : null),
                                            height: 90,
                                            width: 70,
                                          ),
                                        ),
                                        followedPresenters[index].isLive
                                            ? Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                  color: Colors.lightBlue,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate("live")
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 220,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(followedPresenters[index].name),
                                        Text(
                                          followedPresenters[index]
                                              .shortDescription,
                                          softWrap: true,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              if (index == 0)
                                RaisedButton(
                                  color: Colors.lightBlue,
                                  onPressed: () {},
                                  child: Text("message"),
                                )
                            ],
                          )),
                ],
              ),
      ),
    );
  }
}
