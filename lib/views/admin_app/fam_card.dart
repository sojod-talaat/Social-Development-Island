import 'package:flutter/material.dart';
import 'package:island_social_development/models/fam_answer.dart';

class FamilyCard extends StatelessWidget {
  final FamilyStatsModel family;

  const FamilyCard({Key? key, required this.family}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          family.correctAnswersCount == 30 ? Colors.greenAccent : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          Icons.family_restroom,
          color: family.correctAnswersCount == 30 ? Colors.white : Colors.blue,
          size: 30,
        ),
        title: Text(
          family.familyName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                family.correctAnswersCount == 30 ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          "الإجابات الصحيحة: ${family.correctAnswersCount}",
          style: TextStyle(
            fontSize: 16,
            color: family.correctAnswersCount == 30
                ? Colors.white70
                : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
