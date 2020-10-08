import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/view/widgets/loading-widget.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';

class SellerProfilesGridView extends StatelessWidget {
  final ScrollController scrollController = new ScrollController();
  final transformationController = TransformationController();

  final _opacityStream = BehaviorSubject<int>();
  final GlobalKey _globalKey = GlobalKey();
  final List<GlobalKey> _childGlobalKey = new List();


  @override
  Widget build(BuildContext context) {

    print("PRESENTER GRIDVIEW REBUILD");
    return BlocListener<PresenterBloc, PresenterStates>(
      listener: (context, state) {
        if (state is LoadPresenterListSuccess) {
          for (final presenter in state.presenters) {
            _childGlobalKey.add(new GlobalKey());
          }

          _opacityStream.sink.add(4);
        }
      },
      child: BlocBuilder<PresenterBloc, PresenterStates>(
          builder: (context, state) {
        if (state is LoadPresenterListSuccess)
          return Container(
              color: Colors.black,
              key: _globalKey,
              child: InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(double.infinity),
                  transformationController: transformationController,
                  minScale: 0.1,
                  maxScale: 2.5,
                  panEnabled: true,
                  scaleEnabled: true,
                  constrained: false,
                  onInteractionStart: (_) => print("Interaction Started"),
                  onInteractionEnd: (details) {},
                  onInteractionUpdate: (details) {
                    final RenderBox referenceBox =
                        _globalKey.currentContext.findRenderObject();

                    final position = referenceBox.localToGlobal(Offset.zero);
                    final x = position.dx;
                    final y = position.dy;
                    final h = referenceBox.size.height / 2;
                    final w = referenceBox.size.width / 2;

                    final globalX = x + h;
                    final globalY = y + w;
                    print("x:${x + h}   y:${y + w}");

                    for (int i = 0; i < _childGlobalKey.length; ++i) {
                      final RenderBox referenceBox =
                          _childGlobalKey[i].currentContext.findRenderObject();
                      //  referenceBox.

                      final position = referenceBox.localToGlobal(Offset.zero);
                      final x = position.dx;
                      final y = position.dy;
                      if (x < globalX &&
                          y > globalY &&
                          !x.isNegative &&
                          !y.isNegative) {
                        _opacityStream.sink.add(i);
                        print("child[$i] x:$x y:$y");
                        break;
                      }
                    }
                  },
                  child: Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width + 1000,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        shrinkWrap: false,
                        cacheExtent: 1500,
                        addAutomaticKeepAlives: true,
                        controller: scrollController..addListener(() {}),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 1.4),
                        itemCount: state.presenters.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder<int>(
                              stream: _opacityStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                return AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn,
                                  opacity: snapshot.data == null
                                      ? 0.5
                                      : snapshot.data == index ? 1.0 : 0.5,
                                  child: Container(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            bool isGuestUser =
                                                BlocProvider.of<LoginBloc>(
                                                        context)
                                                    .state is GuestUser;

                                            print(
                                                "CHECK ISGUESTUSER: ${BlocProvider.of<LoginBloc>(context).state}");

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
                                                              presenterId: state
                                                                  .presenters[
                                                                      index]
                                                                  .id,
                                                              profileImageURL: state
                                                                  .presenters[
                                                                      index]
                                                                  .profilePicture,
                                                            )),
                                                  );
                                          },
                                          child: Card(
                                            key: _childGlobalKey[index],
                                            elevation: snapshot.data == null
                                                ? 0.0
                                                : snapshot.data == index
                                                    ? 30.0
                                                    : 0.5,
                                            semanticContainer: true,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                                side: snapshot.data == index
                                                    ? BorderSide(
                                                        color: Colors.white,
                                                        width: 2,
                                                        style:
                                                            BorderStyle.solid)
                                                    : BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Stack(
                                              // fit: StackFit.expand,
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      "${GlobalConfiguration().getString("imageURL")}/${state.presenters[index].profilePicture}",
                                                  height: 450,
                                                  width: 350,
                                                  fit: BoxFit.cover,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 24.0),
                                                    child: Text(
                                                      state.presenters[index]
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  )));
        else
          return Container(color: Colors.black, child: spinKit);
      }),
    );
  }
}
