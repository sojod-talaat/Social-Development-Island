import 'package:flutter/material.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/widgets/app_drawer.dart';
import 'package:lucide_icons/lucide_icons.dart'; // مكتبة أيقونات جميلة

class UserHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'حلقات التحفيظ',
      'route': AppRouter.dourat,
      'icon': LucideIcons.bookOpen
    },
    {
      'title': 'البرامج',
      'route': AppRouter.userhome,
      'icon': LucideIcons.calendar
    },
    {'title': 'رمضان', 'route': AppRouter.praytime, 'icon': LucideIcons.moon},
    {
      'title': 'المسابقات',
      'route': AppRouter.userCompetition,
      'icon': LucideIcons.trophy
    },
    {'title': 'عام', 'route': AppRouter.userhome, 'icon': LucideIcons.grid},
    {
      'title': 'الرحلات',
      'route': AppRouter.userhome,
      'icon': LucideIcons.mapPin
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('القائمة الرئيسية'),
        backgroundColor: AppColors.darkBlue,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, items[index]['route']);
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkBlue, AppColors.secondaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[index]['icon'], size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      items[index]['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
