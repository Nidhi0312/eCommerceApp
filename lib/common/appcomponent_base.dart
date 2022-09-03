import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppComponentBase {
  static final AppComponentBase instance =
      AppComponentBase._privateConstructor();

  AppComponentBase._privateConstructor();

  TextStyle myCartStyle = TextStyle(color: Colors.white, fontSize: 14.sp);
  TextStyle noDataStyle = TextStyle(color: Colors.blueAccent, fontSize: 16.sp);
  TextStyle noInternetStyle = TextStyle(color: Colors.red, fontSize: 16.sp);
  TextStyle cartUpdatedStyle = TextStyle(color: Colors.green, fontSize: 16.sp);
}
