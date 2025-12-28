
import 'package:flutter/material.dart';
import 'package:yuva_ride/view/custom_widgets/custom_scaffold_utils.dart';
import 'package:yuva_ride/utils/app_colors.dart';
import 'package:yuva_ride/utils/app_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
 
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      secondary: AppColors.accent,
    ),

    scaffoldBackgroundColor: AppColors.scaffoldBackground,

    appBarTheme:const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.semiBold,
        color: AppColors.white,
      ),
    ),

    textTheme:const TextTheme(
      displayLarge: TextStyle(
        fontSize: 96,
        fontFamily: AppFonts.extraBold,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: 60,
        fontFamily: AppFonts.bold,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontFamily: AppFonts.semiBold,
        color: AppColors.textSecondary,
      ),

      headlineMedium: TextStyle(
        fontSize: 34,
        fontFamily: AppFonts.medium,
        color: AppColors.textSecondary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: AppFonts.medium,
        color: AppColors.textPrimary,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.semiBold,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontFamily: AppFonts.regular,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.medium,
        color: AppColors.textSecondary,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: AppFonts.regular,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.light,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: AppFonts.light,
        color: AppColors.textSecondary,
      ),

      labelLarge: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.semiBold,
        color: AppColors.primaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontFamily: AppFonts.thin,
        color: AppColors.hint,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      hintStyle:const TextStyle(
        color: AppColors.hint,
        fontFamily: AppFonts.light,
      ),
      border: OutlineInputBorder(
        borderSide:const  BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    cardColor: AppColors.cardBackground,
    dividerColor: AppColors.divider,
  );
 
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      secondary: AppColors.accent,
    ),

    scaffoldBackgroundColor: Colors.black,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: AppFonts.semiBold,
        color: AppColors.white,
      ),
    ),

    textTheme:const  TextTheme(
      displayLarge: TextStyle(
        fontSize: 96,
        fontFamily: AppFonts.extraBold,
        color: AppColors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 60,
        fontFamily: AppFonts.bold,
        color: AppColors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontFamily: AppFonts.semiBold,
        color: Colors.white60,
      ),

      headlineMedium: TextStyle(
        fontSize: 34,
        fontFamily: AppFonts.medium,
        color: Colors.white60,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: AppFonts.medium,
        color: AppColors.white,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.semiBold,
        color: AppColors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontFamily: AppFonts.regular,
        color: AppColors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.medium,
        color: Colors.white60,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: AppFonts.regular,
        color: AppColors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.light,
        color: Colors.white60,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: AppFonts.light,
        color: Colors.white60,
      ),

      labelLarge: TextStyle(
        fontSize: 14,
        fontFamily: AppFonts.semiBold,
        color: AppColors.primaryLight,
      ),
      labelSmall:  TextStyle(
        fontSize: 10,
        fontFamily: AppFonts.thin,
        color: Colors.white60,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black87,
      hintStyle: const TextStyle(
        color: Colors.white60,
        fontFamily: AppFonts.light,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white60),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white60),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.primaryLight,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
 
    cardColor: const Color(0xFF212121),
    dividerColor: const Color(0xFF616161),
  ); 
  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
