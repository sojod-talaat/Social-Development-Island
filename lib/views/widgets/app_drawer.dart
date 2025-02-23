import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/settings_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(color: AppColors.darkBlue),
                child: Text(
                  'القائمة الرئيسية',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_2_outlined),
              title: const Text('الوضع الداكن'),
              onTap: () {
                value.toggleTheme();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('من نحن'),
              onTap: () {
                //Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل الخروج'),
              onTap: () async {
                await value.signOut();
                Navigator.pushNamed(context, AppRouter.signin);
              },
            ),
          ],
        ),
      ),
    );
  }
}
