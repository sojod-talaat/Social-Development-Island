import 'dart:convert';

import 'package:island_social_development/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _languageKey = 'language';
  static const String _themeKey = 'theme';
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() {
    return _instance;
  }
  SharedPreferencesHelper._internal();
  Future<UserModel?> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString =
        prefs.getString('user'); // استرجاع البيانات كـ String

    if (userJsonString != null) {
      final userJson = jsonDecode(userJsonString); // تحويل String إلى Map
      return UserModel.fromJson(userJson); // تحويل Map إلى UserModel
    }
    return null; // إذا لم توجد بيانات
  }

  Future<void> saveUserModel(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = user.toJson(); // تحويل UserModel إلى Map
    final userJsonString =
        jsonEncode(userJson); // تحويل Map إلى String بتنسيق JSON
    await prefs.setString('user', userJsonString); // حفظ البيانات
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // حذف البيانات المرتبطة بالمفتاح 'user'
  }

  // دالة لحفظ اللغة
  Future<void> saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  // دالة لاسترجاع اللغة
  Future<String?> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // دالة لحفظ الوضع الليلي (true للوضع الليلي، false للوضع الفاتح)
  Future<void> saveTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // دالة لاسترجاع الوضع الليلي
  Future<bool?> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }

  /// ✅ حفظ عدد الأسئلة المضافة
  Future<void> saveFamQuestionsCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fam_added_questions', count);
  }

  /// ✅ جلب عدد الأسئلة المضافة
  Future<int> getFamQuestionsCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('fam_added_questions') ??
        0; // إذا لم يكن هناك قيمة، ارجِع 0
  }

  //حفظ اسم رب الاسرة
  Future<void> saveFamName(String famName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Fam_Name', famName);
  }

  Future<String> getFamName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Fam_Name') ?? ""; // إذا لم يكن هناك قيمة، ارجِع 0
  }

  Future<void> resetFamName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fam_added_questions', 0);
  }
}
