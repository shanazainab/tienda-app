import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/localization.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

class SellerProfilesGridView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SellerProfilesGridView> {
  ScrollController scrollController = new ScrollController();
  final transformationController = TransformationController();

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
            child: InteractiveViewer(
                boundaryMargin: EdgeInsets.all(20.0),
                transformationController: transformationController,
                minScale: 0.1,
                maxScale: 1.6,
                // You can off zooming by setting scaleEnable to false
                //scaleEnabled: false,
                onInteractionStart: (_) => print("Interaction Started"),
                onInteractionEnd: (details) {
                  setState(() {
                    transformationController.toScene(Offset.zero);
                  });
                },
                onInteractionUpdate: (_) => print("Interaction Updated"),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                  child: GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 1.4),
                    itemCount: state.presenters.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                bool isGuestUser =
                                    BlocProvider.of<LoginBloc>(context).state
                                        is GuestUser;

                                print(
                                    "CHECK ISGUESTUSER: ${BlocProvider.of<LoginBloc>(context).state}");

                                if (state.presenters[index].isLive) {
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
                                                  MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (BuildContext
                                                                context) =>
                                                            LiveStreamCheckoutBloc(),
                                                      ),
                                                      BlocProvider(
                                                          create: (BuildContext
                                                                  context) =>
                                                              LiveStreamBloc()
                                                                ..add(JoinLive(state
                                                                    .presenters[
                                                                        index]
                                                                    .id))),
                                                    ],
                                                    child: LiveStreamScreen(
                                                        state
                                                            .presenters[index]),
                                                  )),
                                        );
                                } else
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
                                                  PresenterProfilePage(state
                                                      .presenters[index].id)),
                                        );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    FadeInImage.memoryNetwork(
                                      image:
                                          "${GlobalConfiguration().getString("imageURL")}/${state.presenters[index].profilePicture}",
                                      height: 450,
                                      width: 350,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 24.0),
                                        child: Text(
                                          state.presenters[index].name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            state.presenters[index].isLive
                                ? Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      color: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("live")
                                              .toUpperCase(),
                                          style: TextStyle(color: Colors.white),
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
                ))));
      else
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
              child: Center(
                  child: Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 20),
            child: GridView.builder(
              controller: scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1.4),
              itemCount: 20,
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
