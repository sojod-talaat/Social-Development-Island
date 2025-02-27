import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/competition__provider.dart';
import 'package:island_social_development/views/admin_app/contests/competition_list.dart';
import 'package:provider/provider.dart';

class CompetitionsScreen extends StatefulWidget {
  @override
  _CompetitionsScreenState createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  int _selectedIndex = 0;
  final List<String> _categories = ["youth", "kids"];

  @override
  void initState() {
    super.initState();
    Provider.of<CompetitionProvider>(context, listen: false)
        .fetchCompetitions(_categories[_selectedIndex]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Provider.of<CompetitionProvider>(context, listen: false)
          .fetchCompetitions(_categories[_selectedIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_categories[_selectedIndex] == "youth"
              ? "مسابقات الشباب"
              : "مسابقات الأطفال"),
          bottom: TabBar(
            tabs: [
              Tab(text: "عامة"),
              Tab(text: "علمية"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CompetitionsList(
                category: _categories[_selectedIndex], type: "general"),
            CompetitionsList(
                category: _categories[_selectedIndex], type: "scientific"),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: "الأطفال",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "الشباب",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
