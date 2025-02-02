import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  /// الانتقال إلى صفحة جديدة باستخدام `push`
  static Future<T?> navigateToWidget<T>(Widget widget) async {
    if (navKey.currentContext == null) return null;
    return await Navigator.of(navKey.currentContext!)
        .push<T>(MaterialPageRoute(builder: (context) => widget));
  }

  /// استبدال الصفحة الحالية بصفحة جديدة (`pushReplacement`)
  static Future<T?> navigateWithReplacement<T>(Widget widget) async {
    if (navKey.currentContext == null) return null;
    return await Navigator.of(navKey.currentContext!)
        .pushReplacement<T, T>(MaterialPageRoute(builder: (context) => widget));
  }

  /// الرجوع (`pop`) إلى الصفحة السابقة
  static void popRouter<T>([T? result]) {
    if (navKey.currentContext != null &&
        Navigator.of(navKey.currentContext!).canPop()) {
      Navigator.of(navKey.currentContext!).pop<T>(result);
    }
  }

  /// الرجوع إلى صفحة معينة (`popUntil`)
  static void popUntil(String routeName) {
    if (navKey.currentContext != null) {
      Navigator.of(navKey.currentContext!)
          .popUntil((route) => route.settings.name == routeName);
    }
  }
}
