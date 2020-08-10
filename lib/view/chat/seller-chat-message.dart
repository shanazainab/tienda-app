import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tienda/bloc/chat-bloc.dart';
import 'package:tienda/bloc/events/chat-events.dart';
import 'package:tienda/bloc/states/chat-states.dart';
import 'package:tienda/model/presenter.dart';

class SellerDirectMessage extends StatefulWidget {
  final Presenter presenter;

  SellerDirectMessage(this.presenter);

  @override
  _SellerDirectMessageState createState() => _SellerDirectMessageState();
}

class _SellerDirectMessageState extends State<SellerDirectMessage> {
  ChatBloc chatBloc = new ChatBloc();

  ScrollController scrollController = new ScrollController();

  TextEditingController messageTextController = new TextEditingController();

  List<ChatMessage> messages = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatBloc.add(Initialize());
    chatBloc.add(GetConversation(senderId: "100", receiverId: widget.presenter.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => chatBloc,
        child: BlocListener<ChatBloc, ChatStates>(
            listener: (context, state) {
//              if (state is FetchMessagesComplete) {
//                messages.add(value)
//              }
            },
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  brightness: Brightness.light,
                  elevation: 0,
                  title: Text(widget.presenter.name),
                ),
                body: BlocBuilder<ChatBloc, ChatStates>(
                    builder: (context, state) {
                  if (state is FetchMessagesComplete) {
                    return DashChat(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      user:
                          ChatUser(uid: '100', name: 'me', color: Colors.blue),
                      text: 'Type you message',
                      alwaysShowSend: true,
                      inputMaxLines: 4,
                      dateFormat: DateFormat('DD mm'),
                      textController: messageTextController,
                      sendOnEnter: true,
                      scrollToBottom: true,
                      timeFormat: DateFormat("h:mm a"),
                      messages: state.chatMessages,
                      onSend: (message) {
                        chatBloc.add(SendMessage(
                            receiverId: '101',
                            chatMessages: state.chatMessages,
                            newMessage: new ChatMessage(
                              text: messageTextController.text,
                              user: ChatUser(uid: '100', name: 'me'),
                            )));
                      },
                    );
                  }
                  if (state is MessageSend) {
                    return DashChat(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      user:
                          ChatUser(uid: '100', name: 'me', color: Colors.blue),
                      text: 'Type you message',
                      alwaysShowSend: true,
                      inputMaxLines: 4,

                      dateFormat: DateFormat('yyyy-MMM-dd'),

                      textController: messageTextController,
                      sendOnEnter: true,
                      scrollToBottom: true,
                      shouldShowLoadEarlier: false,


                      timeFormat: DateFormat("h:mm a"),
                      messages: state.chatMessages,
                      onSend: (message) {
                        chatBloc.add(SendMessage(
                            receiverId: '101',
                            chatMessages: state.chatMessages,
                            newMessage: new ChatMessage(

                              text: messageTextController.text,
                              user: ChatUser(uid: '100', name: 'me',
                              ),
                            )));
                      },
                    );
                  }
                  return DashChat(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    user: ChatUser(uid: '100', name: 'me', color: Colors.blue),
                    text: 'Type you message',
                    alwaysShowSend: true,
                    inputMaxLines: 4,
                    dateFormat: DateFormat('DD mm'),
                    textController: messageTextController,
                    shouldShowLoadEarlier: true,
                    sendOnEnter: true,
                    scrollToBottom: true,
                    timeFormat: DateFormat("h:mm a"),
                    messages: messages,
                    onSend: (message) {
                      chatBloc.add(SendMessage(
                          receiverId: '101',
                          chatMessages: messages,
                          newMessage: new ChatMessage(
                            text: messageTextController.text,
                            user: ChatUser(uid: '100', name: 'me'),
                          )));
                    },
                  );
                }))));
  }
}
