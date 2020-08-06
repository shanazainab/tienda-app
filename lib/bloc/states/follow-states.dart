import 'package:equatable/equatable.dart';


abstract class FollowStates extends Equatable {
  FollowStates();

  @override
  List<Object> get props => null;
}

class Loading extends FollowStates {
  Loading() : super();
}

class ChangeFollowStatusSuccess extends FollowStates {
  final bool isFollowing;

  ChangeFollowStatusSuccess(this.isFollowing) : super();

  @override
  List<Object> get props => [isFollowing];
}
