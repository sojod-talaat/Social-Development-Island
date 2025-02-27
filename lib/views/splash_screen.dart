import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/auth_controller.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/core/localization/app_localization.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';
import 'package:island_social_development/core/theme/app_style.dart';
import 'package:island_social_development/core/utils/app_assets.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/core/utils/hive_box.dart';

import 'package:island_social_development/views/notification.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initNotifications();
    showNotification();
    AuthController.authhelper.checkUserStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    var local = AppLocalizations.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () async {
        //   await AuthController.authhelper.signout();
        //   await prefsHelper.removeUser();
        // }),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.logoImage, width: 150),
              const SizedBox(height: 20),
              Text(local.translate('title'),
                  style:
                      Styles.textStyle20.copyWith(color: AppColors.darkBlue)),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: AppColors.darkBlue)),
            ],
          ),
        ),
      ),
    );
  }
}
