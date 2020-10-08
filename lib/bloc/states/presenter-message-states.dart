import 'package:logger/logger.dart';
import 'package:tienda/model/unread-messages.dart';

abstract class PresenterMessageStates {
  PresenterMessageStates();

  PresenterMessageStates fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(PresenterMessageStates state);
}

class Loading extends PresenterMessageStates {
  Loading() : super();

  @override
  PresenterMessageStates fromJson(Map<String, dynamic> json) {
    Logger().d("LOADING SUCCESS FROM JSON");

    return Loading();
  }

  @override
  Map<String, dynamic> toJson(PresenterMessageStates state) {
    Logger().d("LOADING SUCCESS TO JSON");

    return {};
  }
}

class MessageReceivedSuccess extends PresenterMessageStates {
  List<UnreadMessage> unReadMessages;

  MessageReceivedSuccess({this.unReadMessages}) : super();

  @override
  PresenterMessageStates fromJson(Map<String, dynamic> json) {
    Logger().d("MESSAGERECEIVED SUCCESS FROM JSON");

    return MessageReceivedSuccess(
        unReadMessages: List<UnreadMessage>.from(
            json["messages"].map((x) => UnreadMessage.fromJson(x))));
  }

  @override
  Map<String, dynamic> toJson(PresenterMessageStates state) {

    Logger().d("MESSAGERECEIVED SUCCESS TO JSON");

    return {
      "messages": List<UnreadMessage>.from(unReadMessages.map((x) => x)),
    };
  }
}
