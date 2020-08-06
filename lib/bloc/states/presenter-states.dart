import 'package:equatable/equatable.dart';
import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/model/presenter.dart';

abstract class PresenterStates extends Equatable {
  PresenterStates();

  @override
  List<Object> get props => null;
}

class Loading extends PresenterStates {
  Loading() : super();
}

class LoadPresenterListSuccess extends PresenterStates {
  final PresenterCategory presenterCategory;
  final List<Presenter> presenters;

  LoadPresenterListSuccess(this.presenterCategory, this.presenters) : super();

  @override
  List<Object> get props => [presenterCategory];
}

class LoadPresenterDetailsSuccess extends PresenterStates {
  final Presenter presenter;

  LoadPresenterDetailsSuccess(this.presenter) : super();

  @override
  List<Object> get props => [presenter];
}

