import 'dart:async';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/localization/app_localization.dart';
import 'package:island_social_development/core/localization/locale_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/theme/app_style.dart';
import 'package:island_social_development/core/utils/app_assets.dart';
import 'package:island_social_development/core/utils/app_color.dart';

import 'package:island_social_development/views/auth/sign_up_screen.dart';

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
    // تأخير لمدة 3 ثوانٍ قبل الانتقال إلى الشاشة الرئيسية
    Timer(const Duration(seconds: 5), () {
      AppRouter.navigateToWidget(const SignUPScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        LocaleProvider.changeLanguage();
      }),
      backgroundColor: Colors.white, // تغيير لون الخلفية حسب التصميم
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق
            Image.asset(AssetsConstants.logoImage,
                width: 150), // تأكد من وجود الصورة في assets
            const SizedBox(height: 20),
            Text(local.translate('title'),
                style:
                    Styles.textStyle20.copyWith(color: AppColors.primaryGreen)),
            const SizedBox(
              height: 16,
            ),
            // نص أو تحميل متحرك
            const SizedBox(
                height: 20,
                width: 20,
                child:
                    CircularProgressIndicator(color: AppColors.secondaryGreen)),
          ],
        ),
      ),
    );
  }
}
