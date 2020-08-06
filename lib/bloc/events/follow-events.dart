import 'package:equatable/equatable.dart';

abstract class FollowEvents extends Equatable {
  FollowEvents();

  @override
  List<Object> get props => null;
}

class LoadPresenterList extends FollowEvents {
  LoadPresenterList() : super();

  @override
  List<Object> get props => [];
}



class ChangeFollowStatus extends FollowEvents {
  final int presenterId;

  ChangeFollowStatus(this.presenterId) : super();

  @override
  List<Object> get props => [presenterId];
}