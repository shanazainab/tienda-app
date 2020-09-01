import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/events/presenter-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/bloc/login-bloc.dart';
import 'package:tienda/bloc/presenter-bloc.dart';
import 'package:tienda/bloc/states/login-states.dart';
import 'package:tienda/bloc/states/presenter-states.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:tienda/view/login/login-main-page.dart';
import 'package:tienda/view/presenter-profile/presenter-profile-page.dart';
import 'package:transparent_image/transparent_image.dart';

class ShopLiveScreen extends StatefulWidget {
  @override
  _ShopLiveScreenState createState() => _ShopLiveScreenState();
}

class _ShopLiveScreenState extends State<ShopLiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
        ),
        body: BlocBuilder<PresenterBloc, PresenterStates>(
            cubit: PresenterBloc()
              ..add(LoadLivePresenter()), // provide the local bloc instance
            builder: (context, state) {
              if (state is LoadLivePresenterSuccess &&
                  state.presenters.isNotEmpty)
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height,
                          autoPlay: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: getLivePresenterSliders(state.presenters),
                      ),
                    ],
                  ),
                );
              else if (state is LoadLivePresenterSuccess) {
                return Container(
                  child: Center(child: Text("NO LIVE")),
                );
              } else
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
            }));
  }

  getLivePresenterSliders(List<Presenter> presenters) {
    List<Widget> widgets = new List();

    for (final presenter in presenters) {
      widgets.add(Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.grey[200],
                height: 400,
                width: 390,
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,

                  image:
                      "${GlobalConfiguration().getString("imageURL")}/${presenter.profilePicture}",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              presenter.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                presenter.bio,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: (){
                bool isGuestUser =
                BlocProvider.of<LoginBloc>(context).state
                is GuestUser;

                print(
                    "CHECK ISGUESTUSER: ${BlocProvider.of<LoginBloc>(context).state}");

                if (presenter.isLive) {
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
                                      ..add(JoinLive(presenter
                                          .id))),
                              ],
                              child: LiveStreamScreen(
                                  presenter),
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
                            PresenterProfilePage(presenter.id)),
                  );

              },
              child: Text("JOIN LIVE"),
            )
          ],
        ),
      ));
    }
    return widgets;
  }
}
