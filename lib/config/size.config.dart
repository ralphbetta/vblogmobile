
import 'package:flutter/material.dart';

class AppSize{

  static late MediaQueryData _mediaQueryData;
  static late double screenHeight;
  static late double screenWidth;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
  }

  static double bodyTextSize = 16.0;

  static double extraLarge = 28.0;
  static double large = 20.0;
  static double mediumTextSize = 18.0;
  static double small = 15;

  static double height(double percentage) {
    return AppSize.screenHeight * percentage * 0.01;
  }

  static double width(double percentage) {
    return AppSize.screenWidth * percentage * 0.01;
  }
}