import 'package:flutter/material.dart';

class AppSize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    orientation = _mediaQueryData.orientation;
  }
}

//Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = AppSize.screenHeight;
  //812 is the layout height that designer use
  return (inputHeight / 781) * screenHeight;
}

//Get the proportionate width as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = AppSize.screenWidth;
  //375 is the layout width that designer use
  return (inputWidth / 392) * screenWidth;
}


/*

extension MediaQueryDataProportionate on MediaQueryData {
  /// 812 is the layout height that designer use
  static const double layoutHeight = 812.0;

  /// 375 is the layout width that designer use
  static const double layoutWidth = 315.0;

  /// Get the proportionate height as per screen size.
  double getProportionateScreenHeight(double inputHeight) =>
      (inputHeight / layoutHeight) * size.height;

  /// Get the proportionate height as per screen size.
  double getProportionateScreenWidth(double inputWidth) =>
      (inputWidth / layoutWidth) * size.width;
}

  * Sử dụng
  MediaQuery.of(context).getProportionateScreenHeight(20)

*/
