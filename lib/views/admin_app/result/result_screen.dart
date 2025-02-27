import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/views/admin_app/result/fam_card.dart';
import 'package:provider/provider.dart';
import 'result_card.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<QuizProvider>(context, listen: false);
      provider.getAllFamily();
      provider.loadResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('النتائج'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'نتائج العائلة'),
                Tab(text: 'نتائج المستخدم'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              //Text(value.results[0]['cometitionName']),
              ListView.builder(
                itemCount: value.family.length,
                itemBuilder: (context, index) {
                  return FamilyCard(
                    family: value.family[index],
                  );
                },
              ),
              // 📌 تبويب نتائج المستخدم
              ListView.builder(
                itemCount: value.results.length,
                itemBuilder: (context, index) {
                  final result = value.results[index];
                  Text(result.length.toString());
                  return ResultCard(
                    userName: result['userName'],
                    quizName: result['cometitionName'],
                    score: result['score'],
                    totalQuestions: result['totalQuestions'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
