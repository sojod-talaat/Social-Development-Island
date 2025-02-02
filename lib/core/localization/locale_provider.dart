import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleProvider {
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('ar'));

  static void changeLanguage() async {
    final box = await Hive.openBox('settings'); // فتح الـ Box
    if (locale.value.languageCode == 'ar') {
      locale.value = const Locale('en');
      await box.put('language', 'en'); // حفظ اللغة في Hive
    } else {
      locale.value = const Locale('ar');
      await box.put('language', 'ar');
    }
  }

  static Future<void> loadSavedLanguage() async {
    final box = await Hive.openBox('settings');
    final languageCode = box.get('language', defaultValue: 'ar'); // تحميل اللغة
    locale.value = Locale(languageCode);
  }
}
