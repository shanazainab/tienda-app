import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/presenter-profile/seller-profile-main-page.dart';
import 'package:zoom_widget/zoom_widget.dart';

class SellerProfilesGridView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SellerProfilesGridView> {
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 100);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PresenterBloc, PresenterStates>(
        builder: (context, state) {
      if (state is LoadPresenterListSuccess)
        return Container(
          height: 3000,
          child: Zoom(
              opacityScrollBars: 0.0,
              backgroundColor: Colors.white,
              canvasColor: Colors.white,
              centerOnScale: true,
              enableScroll: true,
              doubleTapZoom: true,
              zoomSensibility: 2.3,
              initZoom: 0.0,
              width: 1000,
              height: 2000,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 100),
                child: GridView.builder(

                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 1.4),
                  itemCount: state.presenters.length,
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellerProfilePage(
                                        state.presenters[index].id)),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
//                                  CachedNetworkImage(
//                                    imageUrl:
//                                        "${GlobalConfiguration().getString("baseURL")}/${state.presenters[index].profilePicture}",
//                                    height: 450,
//                                    width: 350,
//                                    fit: BoxFit.cover,
//                                    placeholder: (context, url) => ClipRRect(
//                                      borderRadius: BorderRadius.circular(16),
//                                      child: Container(
//                                        height: 450,
//                                        width: 350,
//                                        color: Color(0xfff2f2e4),
//                                      ),
//                                    ),
//                                    errorWidget: (context, url, error) =>
//                                        Container(
//                                      height: 450,
//                                      width: 350,
//                                      color: Color(0xfff2f2e4),
//                                    ),
//                                  ),

                                         Image.asset(
                                            "assets/images/avatartwo.jpeg",
                                            height: 450,
                                                                         fit: BoxFit.cover,

                                      width: 350,
                                          ),

                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: Text(
                                          state.presenters[index].name,
                                          style: TextStyle(fontSize: 50),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          state.presenters[index].isLive
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    color: Colors.lightBlue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate("live")
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              ))),
        );
      else
        return Container(
          height: 3000,
          child: Zoom(
              opacityScrollBars: 0.0,
              backgroundColor: Colors.white,
              canvasColor: Colors.white,
              centerOnScale: true,
              enableScroll: true,
              doubleTapZoom: true,
              zoomSensibility: 2.3,
              initZoom: 0.0,
              width: 1000,
              height: 2000,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 100.0, bottom: 100),
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 1.4),
                  itemCount: 50,
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                          color: Colors.grey[200], height: 450, width: 350),
                    ),
                  ),
                ),
              ))),
        );
    });
  }
}
