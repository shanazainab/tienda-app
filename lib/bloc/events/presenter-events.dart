import 'package:equatable/equatable.dart';

abstract class PresenterEvents extends Equatable {
  PresenterEvents();

  @override
  List<Object> get props => null;
}

class LoadPresenterList extends PresenterEvents {
  LoadPresenterList() : super();

  @override
  List<Object> get props => [];
}

class LoadPresenterDetails extends PresenterEvents {
  final int presenterId;

  LoadPresenterDetails(this.presenterId) : super();

  @override
  List<Object> get props => [presenterId];
}

