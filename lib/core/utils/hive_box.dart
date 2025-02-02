import 'package:hive_flutter/adapters.dart';
import 'package:island_social_development/core/localization/locale_provider.dart';
import 'package:path_provider/path_provider.dart';

class HiveBox {
  static void initialze() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    await Hive.openBox('settings');
    await LocaleProvider.loadSavedLanguage();
  }
}
