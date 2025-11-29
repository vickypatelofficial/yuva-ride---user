
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';

class TAppBarTheme {
  // Light theme AppBar
  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black, // Icon color
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  );

  // Dark theme AppBar
  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white, // Icon color
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
}
