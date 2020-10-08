import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final spinKit = SpinKitDoubleBounce(
  color: Colors.grey,
  size: 30,
);
final linearProgress = LinearProgressIndicator(
  backgroundColor: Colors.white,
  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffc30045)),
);
