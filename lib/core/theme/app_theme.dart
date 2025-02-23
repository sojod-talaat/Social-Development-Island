import 'package:flutter/material.dart';
import 'package:island_social_development/core/utils/app_color.dart';

class AppTheme {
  // الثيم العام للتطبيق
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.darkBlue,
    scaffoldBackgroundColor: AppColors.whiteColor,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.0,
        wordSpacing: 2.0,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.8,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        letterSpacing: 1.5,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.lightGrey, width: 2), // اللون العادي
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.darkBlue, width: 2.0), // اللون عند الضغط
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.red, width: 2.0), // اللون عند الخطأ
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkBlue,
    scaffoldBackgroundColor: AppColors.blackColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.lightGrey, width: 2), // اللون العادي
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.darkBlue, width: 2.0), // اللون عند الضغط
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            const BorderSide(color: Colors.red, width: 2.0), // اللون عند الخطأ
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
