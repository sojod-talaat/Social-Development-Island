import 'package:flutter/material.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/admin_app/contests/add_contests.dart';
import 'package:island_social_development/views/admin_app/dourat/add_doura_screen.dart';
import 'package:island_social_development/views/admin_app/result/result_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const AddContests(),
    const AddDouraScreen(),
    const ResultsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.darkBlue,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: ' المسابقة ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'اضافة حلقة ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: ' النتائج',
          ),
        ],
      ),
    );
  }
}
