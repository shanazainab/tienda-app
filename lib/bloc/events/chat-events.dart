import 'package:dash_chat/dash_chat.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvents extends Equatable {
  ChatEvents();

  @override
  List<Object> get props => null;
}

class Initialize extends ChatEvents {
  Initialize() : super();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvents {
  List<ChatMessage> chatMessages;
  final ChatMessage newMessage;
  final String receiverId;

  SendMessage({this.chatMessages, this.newMessage,this.receiverId}) : super();

  @override
  List<Object> get props => [chatMessages, newMessage];
}

class GetMessage extends ChatEvents {
  final String senderId;
  final String receiverId;

  GetMessage({this.senderId, this.receiverId}) : super();

  @override
  List<Object> get props => [senderId, receiverId];
}

class GetConversation extends ChatEvents {
  final String senderId;
  final String receiverId;

  GetConversation({this.senderId, this.receiverId}) : super();

  @override
  List<Object> get props => [senderId, receiverId];
}

class GetAllMessage extends ChatEvents {
  final String senderId;
  final String receiverId;

  GetAllMessage({this.senderId, this.receiverId}) : super();

  @override
  List<Object> get props => [senderId, receiverId];
}
