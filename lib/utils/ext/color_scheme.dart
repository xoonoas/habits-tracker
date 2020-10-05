import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get backgroundRed => brightness == Brightness.light ?const Color(0xFFc62828) : const Color(0xFFe57373);
  Color get backgroundPink => brightness == Brightness.light ?const Color(0xFFad1457) : const Color(0xFFf06292);
  Color get backgroundGreen => brightness == Brightness.light ?const Color(0xFF2e7d32) : const Color(0xFF81c784);
  Color get backgroundYellow => brightness == Brightness.light ?const Color(0xFFf9a825) : const Color(0xFFfff176);
  Color get backgroundBlue => brightness == Brightness.light ?const Color(0xFF1565c0) : const Color(0xFF64b5f6);
  Color get backgroundBrown => brightness == Brightness.light ?const Color(0xFF4e342e) : const Color(0xFFa1887f);
  Color get backgroundPurple => brightness == Brightness.light ?const Color(0xFF6a1b9a) : const Color(0xFFba68c8);
  Color get backgroundIndigo => brightness == Brightness.light ?const Color(0xFF283593) : const Color(0xFF7986cb);
  Color get backgroundOrange => brightness == Brightness.light ?const Color(0xFFd84315) : const Color(0xFFff8a65);
  Color get backgroundCyan => brightness == Brightness.light ?const Color(0xFF00838f) : const Color(0xFF4dd0e1);
}