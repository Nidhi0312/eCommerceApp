import 'package:flutter/foundation.dart';

abstract class AppException implements Exception {
  void onException(String title, StackTrace stack);
}

class CustomException extends AppException {
  CustomException();

  @override
  void onException(String title, StackTrace stack) {
    if (kDebugMode) {
      print("Exception: $title-----> $stack");
    }
  }
}
