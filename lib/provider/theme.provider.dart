import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vblogmobile/config/color.config.dart';

class ThemeClass {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: AppColors.bgColor,
    secondaryHeaderColor: AppColors.whiteLight,
    hintColor: Colors.black.withOpacity(0.4),
    shadowColor: AppColors.shadowW,
    primaryColor: AppColors.primary,
    primaryColorLight: const Color(0xFFC9DFE3), //this affect the textinput and active prefix color
    primaryColorDark:  AppColors.primaryDark,
    splashColor: Colors.transparent,
    appBarTheme:  AppBarTheme(
      backgroundColor: AppColors.bgColor,
      foregroundColor: Colors.transparent,
      elevation: 0,
      iconTheme:const IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    brightness: Brightness.light,
     colorScheme: ColorScheme.fromSeed(
        seedColor:  AppColors.primary,
        primary:
             AppColors.primary).copyWith(background: AppColors.scaffoldWOff),
    textTheme:  const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF4E545D)),
      titleLarge: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    canvasColor: const Color(0xFF101A21),
    scaffoldBackgroundColor: AppColors.scaffoldD,
    shadowColor: AppColors.shadowD,
    secondaryHeaderColor: AppColors.blacklight, //white equ
    primaryColorDark: const Color(0xFFF2F2F2),
    primaryColor:  AppColors.primary,
    hintColor: const Color(0xffA3A3A3),

    splashColor: Colors.transparent,
    appBarTheme:  AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
        seedColor:  AppColors.primary,
        primary:
             AppColors.primary).copyWith(background: AppColors.scaffoldDOff),
    textTheme:  const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.red;
}
