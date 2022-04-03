import 'package:flutter/material.dart';

class CustomTheme {
  // Theme Colors

  static Color red = const Color(0xFFF03D30);
  static Color redAccent = const Color(0xFFFF5A5F);
  static Color blue = const Color(0xFF0063FF);
  static Color blueAccent = const Color(0xFF1E90FF);
  static Color green = const Color(0xFF136C51);
  static Color greenAccent = const Color(0xFF00CC99);
  static Color purple = const Color(0xFF8C00FF);
  static Color purpleAccent = const Color(0xFF663399);

  // Colors

  static Color white = const Color(0xFFF5F5F5);
  static Color light = const Color(0xFFCCCCCC);
  static Color black = const Color(0xFF222222);
  static Color grey = const Color(0xFF777777);
  static Color bgLogoColor = const Color(0xFF121212);

  // Box Shadows

  static List<BoxShadow> spreadShadow = const [
    BoxShadow(
        offset: Offset(0, 15),
        blurRadius: 30,
        color: Color.fromRGBO(0, 0, 0, 0.3))
  ];

  static List<BoxShadow> boxShadow = const [
    BoxShadow(
        offset: Offset(-2, -2),
        blurRadius: 6,
        color: Color.fromRGBO(255, 255, 255, 0.01)),
    BoxShadow(
        offset: Offset(2, 2),
        blurRadius: 6,
        color: Color.fromRGBO(0, 0, 0, 0.8))
  ];
}
