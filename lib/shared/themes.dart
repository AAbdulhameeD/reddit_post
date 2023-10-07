import 'package:flutter/material.dart';

import 'colors.dart';

class Themes {
  static const kPrimaryColor = 0xff111112;
  static const kAppBackGroundColor = 0xffFBFBF1;
  static const kPrimaryTextColor = 0xffffffff;
  static const kPrimaryBackGroundColor = Color(0xff111112);
  static const kScreenBackGroundColor = Color(0xff111112);
  static const kPrimarySwatch = MaterialColor(kPrimaryColor, {
    50: Color(kPrimaryColor),
    100: Color(kPrimaryColor),
    200: Color(kPrimaryColor),
    300: Color(kPrimaryColor),
    400: Color(kPrimaryColor),
    500: Color(kPrimaryColor),
    600: Color(kPrimaryColor),
    700: Color(kPrimaryColor),
    800: Color(kPrimaryColor),
    900: Color(kPrimaryColor)
  });
  static const textTheme = TextTheme(
      displaySmall: TextStyle(
    color: Color(kPrimaryTextColor),
    fontSize: 16,
  ));
  static const kFontFamily = 'CairoRegular';
}
