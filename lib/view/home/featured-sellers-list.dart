import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../app-language.dart';
import '../../localization.dart';

class FeaturedPresentersList extends StatelessWidget {
  final List<Presenter> featurePresenters;

  FeaturedPresentersList(this.featurePresenters);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                AppLocalizations.of(context)
                    .translate('featured-sellers')
                    .toUpperCase(),
                style: TextStyle(color: Colors.grey))),
        ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 200.0,
            maxHeight: 220.0,
          ),
          child: ListView.builder(
              itemCount: featurePresenters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext cxt, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          FirebaseAnalytics().logEvent(
                              name: "HOME_PAGE_CLICK", parameters: {'section_name': 'top-presenters',
                          'item_type':'presenter','item_id':featurePresenters[index].name});



                          bool isGuestUser = BlocProvider.of<LoginBloc>(context)
                              .state is GuestUser;

                          isGuestUser
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginMainPage()),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PresenterProfilePage(
                                            presenterId: featurePresenters[index].id,
                                            presenterName: featurePresenters[index].name,
                                            profileImageURL: featurePresenters[index].profilePicture,
                                              )),

                                );
                        },
                        child:

                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(50.0),
                            //   child: FadeInImage.memoryNetwork(
                            //     image:
                            //         "${GlobalConfiguration().getString("imageURL")}/${featurePresenters[index].profilePicture}",
                            //     fit: BoxFit.cover,
                            //     width: 100,
                            //     height: 100,
                            //     placeholder: kTransparentImage,
                            //   ),
                            // )

                            ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 160,
                            width: 120,
                            color: Colors.grey[200],
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
    );
  }
}
