import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityBloc {
  static final ConnectivityBloc connectivityBloc =
      new ConnectivityBloc._internal();

  factory ConnectivityBloc() {
    return connectivityBloc;
  }

  ConnectivityBloc._internal();

  Connectivity connectivity = new Connectivity();

  final connectivityStream = BehaviorSubject<ConnectivityResult>();

  initializeConnectivityListener() async {
    await Connectivity()
        .checkConnectivity()
        .then((value) => connectivityStream.sink.add(value));
    connectivity.onConnectivityChanged.listen((result) {
      connectivityStream.sink.add(result);
    });
  }
}
