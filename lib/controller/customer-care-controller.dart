import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class CustomerCareController {
  static const platform = const MethodChannel('tienda.dev/zendesk');

  Future<void> startChat() async {
    String result;
    try {
      result = await platform.invokeMethod('getChat');
    } on PlatformException catch (e) {
      result = "Platform Method Error: '${e.message}'.";
    }
    Logger().d("PLATFORM METHODE CALL RESULT FOR CHAT: $result");
  }
}
