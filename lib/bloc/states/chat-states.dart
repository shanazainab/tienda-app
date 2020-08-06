import 'package:dash_chat/dash_chat.dart';

abstract class ChatStates {
  ChatStates();
}

class Loading extends ChatStates {
  Loading() : super();
}
class InitializeComplete extends ChatStates {
  InitializeComplete() : super();
}
class MessageSend extends ChatStates {
  final List<ChatMessage> chatMessages;

  MessageSend({this.chatMessages}) : super();
}

class FetchMessagesComplete extends ChatStates {
  final List<ChatMessage> chatMessages;
  FetchMessagesComplete({this.chatMessages}) : super();
}
class MessageReceived extends ChatStates {
  final List<ChatMessage> chatMessages;
  final ChatMessage newChatMessage;

  MessageReceived({this.chatMessages, this.newChatMessage}) : super();
}
