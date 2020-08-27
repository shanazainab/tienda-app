import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tienda/bloc/events/presenter-message-events.dart';
import 'package:tienda/bloc/states/presenter-message-states.dart';
import 'package:tienda/controller/real-time-controller.dart';
import 'package:tienda/model/unread-messages.dart';

class UnreadMessageHydratedBloc
    extends HydratedBloc<PresenterMessageEvents, PresenterMessageStates> {
  UnreadMessageHydratedBloc() : super(Loading());

  @override
  Stream<PresenterMessageStates> mapEventToState(
      PresenterMessageEvents event) async* {
    if (event is MessageReceivedEvent) {
      yield* _mapFetchProductListToStates(event);
    }
  }

  Stream<PresenterMessageStates> _mapFetchProductListToStates(
      MessageReceivedEvent event) async* {
    yield MessageReceivedSuccess(unReadMessages: event.unReadMessages);
  }

  @override
  PresenterMessageStates fromJson(Map<String, dynamic> json) {
    Logger().d(json['value']);
    Logger().d(json['value']['messages']);

    if (json['value']['messages'] != null) {
      List<UnreadMessage> cachedMessages = List<UnreadMessage>.from(
          json['value']['messages'].map((x) => UnreadMessage.fromJson(x)));
      RealTimeController().loadUnreadMessages(cachedMessages);

      return MessageReceivedSuccess(unReadMessages: cachedMessages);
    }
    return Loading();
  }

  @override
  Map<String, dynamic> toJson(PresenterMessageStates state) =>
      {'value': state?.toJson(state)};
}
