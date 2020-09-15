import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:tienda/app-language.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/view/chat/presenter-direct-message.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

class SellerProfileListView extends StatefulWidget {
  @override
  _SellerProfileListViewState createState() => _SellerProfileListViewState();
}

class _SellerProfileListViewState extends State<SellerProfileListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("PRESENTER LIST VIEW BUILD");
    var appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<PresenterBloc, PresenterStates>(
        builder: (context, state) {
      if (state is LoadPresenterListSuccess)
        return DefaultTabController(

          length: state.presenterCategory.response.length,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
             TabBar(
                    unselectedLabelStyle: TextStyle(color: Colors.grey),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.black),
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.all(8),
                    tabs: getAllCategories(
                        state.presenterCategory.response, appLanguage),
                  ),

                Expanded(
                  flex: 1,
                  child: TabBarView(

                    children: getTabBarViewWidgets(state.presenterCategory),
                  ),
                ),
              ],
            ),
          )
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
        padding: EdgeInsets.all(0),
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
                                                    PresenterProfilePage(
                                                      presenterId: cat
                                                          .presenters[index].id,
                                                      presenterName: cat
                                                          .presenters[index].name,
                                                      profileImageURL: cat
                                                          .presenters[index].profilePicture,
                                                    )),
                                          );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      height: 90,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${GlobalConfiguration().getString("imageURL")}/${cat.presenters[index].profilePicture}",
                                        height: 90,
                                        width: 70,
                                        fit: BoxFit.cover,
                                        placeholder:          (context, url) => Container(
                                          height: 90,
                                          width: 70,
                                          color: Colors.grey[200],


                                        ),

                                  ),
                                    ),
                                  ))
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
                    RaisedButton(
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
                                builder: (context) => PresenterDirectMessage(
                                    cat.presenters[index])),
                          );
                      },
                      color: Colors.grey,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("message")
                            .toUpperCase(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
