import 'package:tienda/model/presenter-category.dart';
import 'package:tienda/model/presenter.dart';

abstract class PresenterStates {
  PresenterStates();
}

class Loading extends PresenterStates {
  Loading() : super();
}

class LoadPresenterListSuccess extends PresenterStates {
  final PresenterCategory presenterCategory;
  final List<Presenter> presenters;

  LoadPresenterListSuccess(this.presenterCategory, this.presenters) : super();
}

class LoadPopularPresentersSuccess extends PresenterStates {
  final List<Presenter> presenters;

  LoadPopularPresentersSuccess({this.presenters}) : super();
}
class LoadPresenterDetailsSuccess extends PresenterStates {
  final Presenter presenter;

  LoadPresenterDetailsSuccess(this.presenter) : super();
}

class LoadLivePresenterSuccess extends PresenterStates {
  final List<Presenter> presenters;

  LoadLivePresenterSuccess(this.presenters) : super();
}

class NotAuthorized extends PresenterStates {
  NotAuthorized() : super();
}
