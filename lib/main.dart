import 'package:flutter/material.dart';
import 'package:island_social_development/core/localization/app_localizations_delegate.dart';
import 'package:island_social_development/core/localization/locale_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/views/splash_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HiveBox.initialze();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: LocaleProvider.locale,
        builder: (context, locale, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: AppRouter.navKey,
              locale: locale,
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                AppLocalizationsDelegate(), // ✅ الترجمة الخاصة بنا
                GlobalMaterialLocalizations
                    .delegate, // ✅ دعم اللغة العربية لـ Material
                GlobalWidgetsLocalizations
                    .delegate, // ✅ دعم الترجمة لعناصر الواجهة
                GlobalCupertinoLocalizations
                    .delegate, // ✅ دعم الترجمة لعناصر iOS
              ],
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const SplashScreen());
        });
  }
}


// /lib
// │── main.dart                  # نقطة البداية للتطبيق
// │── app.dart                   # ملف إعداد التطبيق
// │
// ├── core/                      # يحتوي على الكود المشترك بين جميع أجزاء التطبيق
// │   ├── services/              # خدمات مثل API، قاعدة البيانات، التخزين المحلي
// │   │   ├── api_service.dart
// │   │   ├── firebase_service.dart
// │   │   ├── local_storage.dart
// │   │
// │   ├── utils/                 # أدوات مساعدة مثل التنسيقات، التحويلات
// │   │   ├── constants.dart
// │   │   ├── helpers.dart
// │   │
// │   ├── routing/               # إدارة التوجيه والتنقل بين الصفحات
// │   │   ├── app_router.dart
// │   │
// │   ├── theme/                 # ملفات الثيم والألوان
// │   │   ├── app_theme.dart
// │
// ├── models/                    # النماذج (Model)
// │   ├── user_model.dart
// │   ├── product_model.dart
// │
// ├── views/                     # واجهة المستخدم (View)
// │   ├── home/                  
// │   │   ├── home_screen.dart
// │   │   ├── home_widgets.dart
// │   │
// │   ├── auth/                  
// │   │   ├── login_screen.dart
// │   │   ├── signup_screen.dart
// │
// ├── controllers/               # إدارة البيانات والمنطق (Controller)
// │   ├── home_controller.dart
// │   ├── auth_controller.dart
// │   ├── product_controller.dart
// │
// ├── widgets/                   # عناصر UI القابلة لإعادة الاستخدام
// │   ├── custom_button.dart
// │   ├── custom_textfield.dart
// │
// └── localization/              # ملفات الترجمة ودعم اللغات
//     ├── app_localizations.dart
//     ├── en.json
//     ├── ar.json

