import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter/page/presenter-profile-page.dart';
import 'package:tienda/view/presenter/page/profies-listing-page.dart';

import '../../../app-language.dart';

class PopularPresentersList extends StatelessWidget {
  final List<Presenter> featurePresenters;

  PopularPresentersList(this.featurePresenters);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Padding(
      padding: const EdgeInsets.only(left:12,right:12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Popular Presenters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfilesListingPage();
                  }));
                },
                child: Text("See All".toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: Color(0xffc30045),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 235.0,
              maxHeight: 270.0,
            ),
            child: ListView.builder(
                itemCount: featurePresenters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext cxt, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            ///Log section click
                            ///Section name
                            ///Item type
                            /// Item id
                            FirebaseAnalytics()
                                .logEvent(name: "HOME_PAGE_CLICK", parameters: {
                              'section_name': 'top-presenters',
                              'item_type': 'presenter',
                              'item_id': featurePresenters[index].name
                            });

                            bool isGuestUser =
                                BlocProvider.of<LoginBloc>(context).state
                                    is GuestUser;

                            isGuestUser
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginMainPage()),
                                  )
                                : Navigator.of(context, rootNavigator: true)
                                    .push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PresenterProfilePage(
                                              presenterId:
                                                  featurePresenters[index].id,
                                              profileImageURL:
                                                  featurePresenters[index]
                                                      .profilePicture,
                                            )),
                                  );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 123,
                              height: 217,
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${GlobalConfiguration().getString("imageURL")}/${featurePresenters[index].profilePicture}",
                                height: 160,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            featurePresenters[index].name,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Text("Rating")
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
