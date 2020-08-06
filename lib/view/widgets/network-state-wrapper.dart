import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tienda/bloc/connectivity-bloc.dart';
import 'dart:developer' as developer;

typedef NetworkState(ConnectivityResult result);

class NetworkStateWrapper extends StatelessWidget {
  final Widget child;
  final double opacity;
  final NetworkState networkState;

  NetworkStateWrapper({this.child, this.opacity = 0.5, this.networkState});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ConnectivityBloc().connectivityStream,
        builder:
            (BuildContext ctxt, AsyncSnapshot<ConnectivityResult> snapShot) {
          if (snapShot.data == ConnectivityResult.wifi) {
            networkState(ConnectivityResult.wifi);
            print("CONNECTIVITY: WIFI");
            return child;
          }
          if (snapShot.data == ConnectivityResult.mobile) {
            print("CONNECTIVITY: CELLULAR");
            networkState(ConnectivityResult.mobile);

            return Opacity(
              opacity: opacity,
              child: child,
            );
          }
          if (snapShot.data == ConnectivityResult.none) {
            print("CONNECTIVITY: NONE");

            networkState(ConnectivityResult.none);
            return opacity != 0
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.1,
                        child: child,
                      ),
                      ConnectivityErrorPage(),
                    ],
                  )
                : child;
          } else
            return Container();
        });
  }
}

class ConnectivityErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          "Oops !! check your connectivity",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
