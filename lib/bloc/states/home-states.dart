import 'package:tienda/model/home-screen-data-response.dart';

abstract class HomeStates {
  HomeStates();
}

class Loading extends HomeStates {
  Loading() : super();
}

class LoadDataSuccess extends HomeStates {
  final HomeScreenResponse homeScreenResponse;

  LoadDataSuccess(this.homeScreenResponse) : super();
}



class LoadDataFail extends HomeStates {
  final dynamic error;

  LoadDataFail(this.error) : super();
}
