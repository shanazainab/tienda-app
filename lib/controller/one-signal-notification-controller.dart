import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/chat-history-response.dart';
import 'package:tienda/model/home-screen-data-response.dart';
import 'package:tienda/model/presenter.dart';
import 'package:tienda/model/unread-messages.dart';
import 'package:tienda/view/chat/presenter-direct-message.dart';
import 'package:tienda/view/checkout/cart-page.dart';
import 'package:tienda/view/live-stream/live-stream-pop-up.dart';
import 'package:tienda/view/widgets/cart-reminder-dialogue.dart';

import '../main.dart';

class LiveNotification {
  String presenterName;
  String description;
  String imageURL;
  int presenterId;

  LiveNotification(
      {this.presenterName, this.description, this.imageURL, this.presenterId});
}

class OneSignalNotificationController {
  final liveNotOpenedStream = new BehaviorSubject<Presenter>();
  final liveNotReceivedStream = new BehaviorSubject<LiveNotification>();

  OneSignalNotificationController._privateConstructor();

  static final OneSignalNotificationController _instance =
      OneSignalNotificationController._privateConstructor();

  factory OneSignalNotificationController() {
    return _instance;
  }

  changeNotificationType(OSNotificationDisplayType type) {
    OneSignal.shared.setInFocusDisplayType(type);
  }

  initializeListeners() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.init("ba300aff-42f3-4c6a-b235-1e796272dfa2",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: false
        });

    OSPermissionSubscriptionState subscriptionState =
        await OneSignal.shared.getPermissionSubscriptionState();
    Logger().d("PLAYER ID: ${subscriptionState.subscriptionStatus.userId}");

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      Logger().d(notification.jsonRepresentation());

      ///"custom": "{"a":{"presenter_id":10,"type":"presenter_message"},"i":"447dee48-0c14-4862-8106-6c8c3fcbf175"}",

      ///  navigatorKey.currentState.overlay.context

      ///handle live stream
      ///"custom": "{"a":{"presenter_id":10,"name":"Bella","profile_picture":"/media/sampleone.jpg","type":"live_stream"},"i":"a82b55da-ef56-42ab-96a4-d71aef04627f"}",
      if (notification.payload.additionalData['type'] == "live_stream") {
//        liveNotReceivedStream.add(LiveNotification(
//            presenterId: notification.payload.additionalData['presenter_id'],
//            imageURL: notification.payload.additionalData['profile_picture'],
//            description: "some random text message",
//            presenterName: notification.payload.additionalData['name']));

        ///show dialog
        showDialog(
            context: navigatorKey.currentState.overlay.context,
            builder: (BuildContext context) => LiveStreamPopUp(LiveNotification(
                presenterId:
                    notification.payload.additionalData['presenter_id'],
                imageURL:
                    notification.payload.additionalData['profile_picture'],
                description: "some random text message",
                presenterName: notification.payload.additionalData['name'])));
      }

      ///handle presenter message
      if (notification.payload.additionalData['type'] == "presenter_message") {
        RealTimeController realTimeController = new RealTimeController();

        realTimeController.receiveUnreadMessages(new UnreadMessage(
            name: notification.payload.additionalData['name'],
            profileImage:
                notification.payload.additionalData['profile_picture'],
            messages: [notification.payload.additionalData['body']],
            presenterId: notification.payload.additionalData['presenter_id'],
            elapsedTime: notification.payload.rawPayload['google.sent_time']));

        realTimeController.addToAllMessageStream(new Message(
            name: notification.payload.additionalData['name'],
            id: notification.payload.additionalData['presenter_id'],
            lastMessage: notification.payload.additionalData['body'],
            elapsedTime: notification.payload.rawPayload['google.sent_time'],
            profilePicture:
                notification.payload.additionalData['profile_picture']));
      }
    });

    ///TODO:
    ///cart_checkout
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (result.notification.payload.additionalData['type'] == "live_stream") {


        liveNotOpenedStream.add(new Presenter(
            id: result.notification.payload.additionalData['presenter_id'],
            name: result.notification.payload.additionalData['name'],
            profilePicture:
                result.notification.payload.additionalData['profile_picture']));
      } else if (result.notification.payload.additionalData['type'] ==
          "presenter_message") {
        Navigator.push(
          navigatorKey.currentContext,
          MaterialPageRoute(
              builder: (context) => PresenterDirectMessage(new Presenter(
                  id: result
                      .notification.payload.additionalData['presenter_id'],
                  name: result.notification.payload.additionalData['name'],
                  profilePicture: result.notification.payload
                      .additionalData['profile_picture']))),
        );
      }
      else if (result.notification.payload.additionalData['type'] ==
          "cart_checkout") {
        showDialog(
            context: navigatorKey.currentState.overlay.context,
            builder: (BuildContext context) => CartReminderDialogue());
      }
    });
  }
}
