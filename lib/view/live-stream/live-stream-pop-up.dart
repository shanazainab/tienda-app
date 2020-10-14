import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tienda/bloc/events/live-stream-events.dart';
import 'package:tienda/bloc/live-stream-bloc.dart';
import 'package:tienda/bloc/live-stream-checkout-bloc.dart';
import 'package:tienda/controller/one-signal-notification-controller.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/view/live-stream/live-stream-screen.dart';
import 'package:transparent_image/transparent_image.dart';

class LiveStreamPopUp extends StatelessWidget {
  final LiveNotification liveNotification;

  LiveStreamPopUp(this.liveNotification);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 200,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            Container(
              color: Colors.grey[200],
              height: 120,
              width: 100,
              child: FadeInImage.memoryNetwork(
                image:
                    "${GlobalConfiguration().getString("imageURL")}/${liveNotification.imageURL}",
                height: 90,
                width: 80,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                liveNotification.presenterName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("${liveNotification.presenterName} is now live !!"),
            ),
            //  Text("Check out more on sample sample"),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16.0),
              child: RaisedButton(
                child: Text("JOIN LIVE"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (BuildContext context) =>
                                      LiveStreamCheckoutBloc(),
                                ),
                                BlocProvider(
                                    create: (BuildContext context) =>
                                        LiveStreamBloc()
                                          ..add(JoinLive(
                                              liveNotification.presenterId))),
                              ],
                              child: LiveStreamScreen(
                                  new Presenter(
                                    name: liveNotification.presenterName,
                                    id: liveNotification.presenterId,
                                    profilePicture: liveNotification.imageURL,
                                  )),
                            )),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
