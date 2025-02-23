import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/views/admin_app/add_question_screen.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CometitionScreenState();
}

class _CometitionScreenState extends State<CompetitionScreen> {
  @override
  Widget build(BuildContext context) {
    CompetitionModel competitionModel;
    // final douratKey = GlobalKey<FormState>();
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) => Scaffold(
        appBar: AppBar(title: const Text('اضافة مسابقة  جديدة ')),
        body: Form(
          key: quizProvider.competitioKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('قم باضافة مسابقة   جديدة '),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      validator: (value) =>
                          quizProvider.validateCompetitionName(value ?? ''),

                      controller: quizProvider.contestName,
                      //prefix: const Icon(Icons.person_outline),
                      hint: 'اسم المسابقة  ',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      validator: (value) =>
                          quizProvider.validateCompetitonLength(value ?? ''),

                      controller: quizProvider.conestlenght,
                      //prefix: const Icon(Icons.person_outline),
                      hint: ' عدد الاسئلة  ',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      validator: (value) =>
                          quizProvider.validateCompetitonLength(value ?? ''),

                      controller: quizProvider.timerController,
                      //prefix: const Icon(Icons.person_outline),
                      hint: '  مدة المسابقة   ',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      suffix: IconButton(
                        onPressed: () {
                          //quizProvider.setTimerDuration(context);
                        },
                        icon: const Icon(Icons.timer),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          if (quizProvider.competitioKey.currentState!
                              .validate()) {
                            competitionModel = quizProvider.addQuiz();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddQuestionsPage(
                                  count: competitionModel.questionCount,
                                  id: competitionModel.id,
                                  type: 2,
                                ),
                              ),
                            );
                            quizProvider.contestName.clear();
                            quizProvider.conestlenght.clear();
                            quizProvider.timerController.clear();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.darkBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: const Text('انتقل لاضافة الاسئلة '),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
