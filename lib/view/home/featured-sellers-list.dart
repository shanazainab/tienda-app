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

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                    AppLocalizations.of(context).translate('featured-sellers'),
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              )),
          SizedBox(
            height: appLanguage.appLocal == Locale('en') ? 230 : 250,
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
                            bool isGuestUser =
                                BlocProvider.of<LoginBloc>(context).state
                                    is GuestUser;

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
                                                featurePresenters[index].id)),
                                  );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 160,
                              width: 120,
                              color: Colors.grey[200],
                              child: FadeInImage.memoryNetwork(
                                image:
                                    "${GlobalConfiguration().getString("imageURL")}/${featurePresenters[index].profilePicture}",
                                height: 160,
                                width: 120,
                                fit: BoxFit.cover,
                                placeholder: kTransparentImage,

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
