import 'package:ansicolor/ansicolor.dart';
import 'package:dio/dio.dart';

class ConsoleLogger {
  AnsiPen pen = new AnsiPen()..green();
  AnsiPen er = new AnsiPen()..red();
  printResponse(String value) {
    print(pen(value));
  }

  printError(String error) {}

  printDioError(String api, DioError error) {
    print(er(api));
    print(er("${error.response}"));

    print(er("${error.response?.data}"));
    print(er('%%%%%REQUEST%%%%'));

    print(er("${error.request?.data}"));
  }
}
