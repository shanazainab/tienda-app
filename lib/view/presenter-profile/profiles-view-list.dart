import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/chat/presenter-direct-message.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

class SellerProfilesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<PresenterBloc, PresenterStates>(
        builder: (context, state) {
      if (state is LoadPresenterListSuccess)
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: DefaultTabController(
            length: state.presenterCategory.response.length,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                bottom: TabBar(
                  unselectedLabelStyle: TextStyle(color: Colors.grey),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.lightBlue),
                  labelColor: Colors.lightBlue,
                  labelPadding: EdgeInsets.all(8),
                  tabs: getAllCategories(
                      state.presenterCategory.response, appLanguage),
                ),
              ),
              body: TabBarView(
                children: getTabBarViewWidgets(state.presenterCategory),
              ),
            ),
          ),
        );
      else
        return Container();
    });
  }

  getAllCategories(List<Response> response, AppLanguage appLanguage) {
    List<Widget> categories = new List();
    for (final cat in response) {
      categories.add(Text(appLanguage.appLocal == Locale('en')
          ? cat.nameEn.toUpperCase()
          : cat.nameAr));
    }
    return categories;
  }

  getTabBarViewWidgets(PresenterCategory presenterCategory) {
    List<Widget> views = new List();
    for (final cat in presenterCategory.response) {
      views.add(new ListView.builder(
          itemCount: cat.presenters.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 70,
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    bool isGuestUser =
                                        BlocProvider.of<LoginBloc>(context)
                                            .state is GuestUser;

                                    isGuestUser
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginMainPage()),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PresenterProfilePage(cat
                                                        .presenters[index].id)),
                                          );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 90,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: cat.presenters[index].isLive
                                              ? Border.all(
                                                  color: Colors.lightBlue)
                                              : null),
                                      child: FadeInImage.memoryNetwork(
                                        image:
                                            "${GlobalConfiguration().getString("imageURL")}/${cat.presenters[index].profilePicture}",
                                        height: 90,
                                        width: 70,
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                      ),
                                    ),
                                  )

//                                Container(
//                                  decoration: BoxDecoration(
//                                      image: DecorationImage(
//                                        fit: BoxFit.cover,
//                                          image: NetworkImage(
//                                        "${GlobalConfiguration().getString("baseURL")}/${cat.presenters[index].profilePicture}",
//                                      )),
//                                      borderRadius: BorderRadius.circular(4),
//                                      border: cat.presenters[index].isLive
//                                          ? Border.all(color: Colors.lightBlue)
//                                          : null),
//                                  height: 90,
//                                  width: 70,
//                                ),
                                  ),
                              cat.presenters[index].isLive
                                  ? Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        color: Colors.lightBlue,
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            AppLocalizations.of(context)
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
                        Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  cat.presenters[index].name,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  cat.presenters[index].shortDescription,
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    cat.presenters[index].isLive
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (BuildContext context) =>
                                                LiveStreamBloc()
                                                  ..add(JoinLive(cat
                                                      .presenters[index].id)),
                                            child: LiveStreamScreen(
                                                cat.presenters[index]),
                                          )));
                            },
                            color: Colors.blue,
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("join")
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          )
                        : RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onPressed: () {
                              if (presenterCategory.membership != "premium") {
                                ///show premium alert
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Go Premium'),
                                        content: Text(
                                            'Grab a premium membership to send messages'),
                                        actions: <Widget>[
                                          Center(
                                            child: RaisedButton(
                                              onPressed: () {},
                                              child: Text('CONTINUE'),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              } else
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PresenterDirectMessage(
                                              cat.presenters[index])),
                                );
                            },
                            color: Colors.grey,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate("message")
                                  .toUpperCase(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          )
                  ],
                ),
              ),
            );
          }));
    }

    return views;
  }
}
