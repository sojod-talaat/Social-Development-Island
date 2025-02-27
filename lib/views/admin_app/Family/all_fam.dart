import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/models/quiz_model.dart';
import 'package:island_social_development/views/admin_app/Family/add_fam.dart';
import 'package:island_social_development/views/admin_app/Family/quiz_question.dart';
import 'package:island_social_development/views/admin_app/contests/add_question_screen.dart';
import 'package:provider/provider.dart';

class AllQuizesScreen extends StatelessWidget {
  final List<QuizModel> quiz;

  const AllQuizesScreen({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "المسابقات",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FamilyDate()));
                  },
                ),
              ],
            ),
          ],
          centerTitle: true,
          backgroundColor: AppColors.darkBlue, // لون أنيق لشريط التطبيق
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppColors.lightGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: value.quizes.isEmpty
              ? const Center(
                  child: Text('!لا يوجد مسابقات حتى الان '),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: quiz.length,
                  itemBuilder: (context, index) {
                    final competition = quiz[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.3),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => QuestionsScreen(
                                      quizId: competition.quizName,
                                    )));
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.darkBlue,
                                  AppColors.primaryGreen
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.emoji_events,
                                    color: Colors.white, size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        competition.quizName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "تاريخ بدء المسابقة : ${competition.startDate}",
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddQuestionsPage(
                                                        id: competition
                                                            .quizName,
                                                        count: 30,
                                                        type: 1)));
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        value.removeQuiz(competition.quizName);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
