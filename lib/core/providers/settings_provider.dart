import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/auth_controller.dart';
import 'package:island_social_development/core/theme/app_theme.dart';
import 'package:island_social_development/core/utils/hive_box.dart';

class SettingsProvider with ChangeNotifier {
  SettingsProvider() {
    loadSavedTheme();
  }
  // الحصول على نسخة Singleton من SharedPreferencesHelper
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  /////////////////////////////////////////////////////////////////////الثيم
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    prefsHelper.saveTheme(isDarkMode);
    notifyListeners();
  }

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeData get currentThemeData =>
      _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  Future<void> loadSavedTheme() async {
    prefsHelper.getTheme();
    notifyListeners();
  }

  signOut() async {
    await AuthController.authhelper.signout();
  }
}
