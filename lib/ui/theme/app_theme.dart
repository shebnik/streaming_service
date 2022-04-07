import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF8D6CEA);
  static const Color deepBlack = Color(0xFF181818);
  static const Color blackMatte = Color(0xFF343434);
  static const Color brightWhite = Color(0xFFFFFFFF);
  static const Color grayMiddle = Color(0xFF999999);
  static const Color grayDeep = Color(0xFF525252);

  static final ThemeData _themeDark = ThemeData.dark();

  static ThemeData themeDark = _themeDark.copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: blackMatte,
    // colorScheme: _colorSchemeLight(_themeLight.colorScheme),
    // appBarTheme: _appBarLight(_themeLight.appBarTheme),
    // textTheme: _textLight(_themeLight.textTheme),
    // buttonTheme: _buttonLight(_themeLight.buttonTheme),
    // progressIndicatorTheme:
    //     _progressIndicatorLight(_themeLight.progressIndicatorTheme),
    // cardTheme: _cardLight(_themeLight.cardTheme),
    // bottomNavigationBarTheme:
    //     _bottomAppBarLight(_themeLight.bottomNavigationBarTheme),
    // chipTheme: _chipLight(_themeLight.chipTheme),
    // dialogBackgroundColor: Colors.grey,
  );
}
