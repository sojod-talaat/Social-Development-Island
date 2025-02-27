import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:provider/provider.dart';

class TypeContestScreen extends StatelessWidget {
  const TypeContestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) => Scaffold(
          appBar: AppBar(title: const Text('اضافة مسابقة جديدة')),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () async {
                quizProvider.changetype(1);

                await quizProvider.getCompetitions2(
                    quizProvider.getCategory(quizProvider.category),
                    context,
                    quizProvider.getType(1));
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, AppRouter.adminCometition);
              },
              child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5, // لإضافة ظل جميل للكارد
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "المسابقات الشرعية  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(),
                          ]))),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                quizProvider.changetype(2);
                await quizProvider.getCompetitions2(
                    quizProvider.getCategory(quizProvider.category),
                    context,
                    quizProvider.getType(2));
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, AppRouter.adminCometition);
              },
              child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5, // لإضافة ظل جميل للكارد
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "  المسابقات العلمية  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(),
                          ]))),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                quizProvider.changetype(3);

                await quizProvider.getCompetitions2(
                    quizProvider.getCategory(quizProvider.category),
                    context,
                    quizProvider.getType(3));
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, AppRouter.adminCometition);
              },
              child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5, // لإضافة ظل جميل للكارد
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "  المسابقات العامة   ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Divider(),
                          ]))),
            ),
          ])),
    );
  }
}
