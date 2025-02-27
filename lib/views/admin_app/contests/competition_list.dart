import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/competition__provider.dart';
import 'package:provider/provider.dart';

class CompetitionsList extends StatelessWidget {
  final String category;
  final String type;

  CompetitionsList({required this.category, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<CompetitionProvider>(
      builder: (context, provider, child) {
        if (provider.competitions.isEmpty) {
          return Center(child: Text("لا توجد مسابقات متاحة"));
        }

        return ListView.builder(
          itemCount: provider.competitions.length,
          itemBuilder: (context, index) {
            var competition = provider.competitions[index];
            return ListTile(
              title: Text(competition["title"] ?? "مسابقة بدون عنوان"),
              subtitle: Text(competition["description"] ?? "بدون وصف"),
            );
          },
        );
      },
    );
  }
}
