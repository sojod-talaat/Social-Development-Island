import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:island_social_development/core/localization/app_localizations_delegate.dart';
import 'package:island_social_development/core/providers/app_provider.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/providers/settings_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/theme/app_theme.dart';
import 'package:island_social_development/firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => SettingsProvider(),
    child: MyApp(
      appRouter: AppRouter(),
    ),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  AppRouter appRouter;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key, required this.appRouter});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generatedRoute,
        initialRoute: AppRouter.initial,
        locale: Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        themeMode: settingsProvider.currentTheme,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const [
          AppLocalizationsDelegate(), // ✅ الترجمة الخاصة بنا
          GlobalMaterialLocalizations
              .delegate, // ✅ دعم اللغة العربية لـ Material
          GlobalWidgetsLocalizations.delegate, // ✅ دعم الترجمة لعناصر الواجهة
          GlobalCupertinoLocalizations.delegate, // ✅ دعم الترجمة لعناصر iOS
        ],
      ),
    );
  }
}
