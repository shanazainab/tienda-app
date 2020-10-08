
abstract class PresenterEvents {
  PresenterEvents();
}

class LoadPresenterList extends PresenterEvents {
  LoadPresenterList() : super();
}

class LoadPresenterDetails extends PresenterEvents {
  final int presenterId;

  LoadPresenterDetails(this.presenterId) : super();
}
class LoadLivePresenter extends PresenterEvents {

  LoadLivePresenter() : super();
}

class LoadPopularPresenters extends PresenterEvents {
  LoadPopularPresenters() : super();
}
