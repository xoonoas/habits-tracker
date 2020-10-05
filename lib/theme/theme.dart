import 'package:flutter/material.dart';

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: Color(0xFF1565c0),
      accentColor: Color(0xFF00bcd4),
      colorScheme: ColorScheme.light(
        background: Color(0XFFF4F3F9),
        onPrimary: Colors.black87,
      ),
      errorColor: Color(0xFFc62828)
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
      primaryColor: Color(0xFF64b5f6),
      accentColor: Color(0xFF00bcd4),
      colorScheme: ColorScheme.dark(
        background: Color(0XFF78787A),
        onPrimary: Colors.white,
      ),
      errorColor: Color(0xFFe57373)
  );
}

ThemeData buildTheme(bool isLightMode) {
  return isLightMode ? _buildLightTheme() : _buildDarkTheme();
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  CustomColor customColor;

  ThemeNotifier(this._themeData, this.customColor);

  getTheme() => _themeData;

  getCustomColor() => customColor;

  setTheme(bool isLight) async {
    _themeData = buildTheme(isLight);
    customColor = buildCustomColor(isLight);
    notifyListeners();
  }
}

class CustomColor {
  final Color colorRed;
  final Color colorPink;
  final Color colorGreen;
  final Color colorYellow;
  final Color colorBlue;
  final Color colorBrown;
  final Color colorPurple;
  final Color colorIndigo;
  final Color colorOrange;
  final Color colorCyan;

  CustomColor(
      {this.colorRed,
        this.colorPink,
        this.colorGreen,
        this.colorYellow,
        this.colorBlue,
        this.colorBrown,
        this.colorPurple,
        this.colorIndigo,
        this.colorOrange,
        this.colorCyan});
}

buildCustomColor(isLight) {
  if (isLight) {
    return CustomColor(
      /*colorRed: Color(0xFFc62828),
      colorPink: Color(0xFFad1457),
      colorGreen: Color(0xFF2e7d32),
      colorYellow: Color(0xFFf9a825),
      colorBlue: Color(0xFF1565c0),
      colorBrown: Color(0xFF4e342e),
      colorPurple: Color(0xFF6a1b9a),
      colorIndigo: Color(0xFF283593),
      colorOrange: Color(0xFFd84315),
      colorCyan: Color(0xFF00838f)*/
      colorRed: Color(0xFFe57373),
      colorPink: Color(0xFFf06292),
      colorGreen: Color(0xFF81c784),
      colorYellow: Color(0xFFfff176),
      colorBlue: Color(0xFF64b5f6),
      colorBrown: Color(0xFFa1887f),
      colorPurple: Color(0xFFba68c8),
      colorIndigo: Color(0xFF7986cb),
      colorOrange: Color(0xFFff8a65),
      colorCyan: Color(0xFF4dd0e1),
    );
  } else {
    return CustomColor(
        colorRed: Color(0xFFe57373),
        colorPink: Color(0xFFf06292),
        colorGreen: Color(0xFF81c784),
        colorYellow: Color(0xFFfff176),
        colorBlue: Color(0xFF64b5f6),
        colorBrown: Color(0xFFa1887f),
        colorPurple: Color(0xFFba68c8),
        colorIndigo: Color(0xFF7986cb),
        colorOrange: Color(0xFFff8a65),
        colorCyan: Color(0xFF4dd0e1));
  }
}
