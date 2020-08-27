import 'package:tienda/model/unread-messages.dart';

abstract class PresenterMessageEvents {
  PresenterMessageEvents();
}

class MessageReceivedEvent extends PresenterMessageEvents {
  List<UnreadMessage> unReadMessages;

  MessageReceivedEvent(this.unReadMessages) : super();
}
