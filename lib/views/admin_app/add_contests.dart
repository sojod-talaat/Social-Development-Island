import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/admin_app/add_question_screen.dart';
import 'package:island_social_development/views/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AddContests extends StatelessWidget {
  const AddContests({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizPovider, child) => Scaffold(
          appBar: AppBar(title: const Text('اضافة مسابقة جديدة')),
          drawer: const AppDrawer(),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () {
                quizPovider.chaneCategory(1);
                Navigator.pushNamed(
                  context,
                  AppRouter.typecontest,
                );
              },
              child: Card(
                  color: AppColors.darkBlue,
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
                              "مسابقات  الشباب",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.whiteColor),
                            ),
                            Divider(),
                          ]))),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                quizPovider.chaneCategory(2);
                log(quizPovider.category.toString());
                Navigator.pushNamed(context, AppRouter.typecontest);
              },
              child: Card(
                  color: AppColors.darkBlue,
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
                              "مسابقات  الأطفال ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.whiteColor),
                            ),
                            Divider(),
                          ]))),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionsPage(
                        count: quizPovider.maxQuestions,
                        id: '',
                        type: 1,
                      ),
                    ));
              },
              child: Card(
                  color: AppColors.darkBlue,
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
                              "مسابقات  الأسرة ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.whiteColor),
                            ),
                            Divider(),
                          ]))),
            ),
          ])),
    );
  }
}
