import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/core/utils/shared_prefrence.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/views/user_app/widgets/opetion_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';

class FamQuestionScreen extends StatefulWidget {
  QuestionModel todayQuestion;
  FamQuestionScreen({super.key, required this.todayQuestion});

  @override
  _FamQuestionScreenState createState() => _FamQuestionScreenState();
}

class _FamQuestionScreenState extends State<FamQuestionScreen> {
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  int correctAnswersCount = 0;
  String? selectedAnswer;
  bool hasAnswered = false;
  bool isAnswerCorrect = false;
  String familyName = '';
  DateTime? lastAnsweredDate;

  Future<void> _submitAnswer() async {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("الرجاء اختيار إجابة")));
      return;
    }

    bool isCorrect = widget.todayQuestion.correctAnswer == selectedAnswer;
    await FirebaseFirestore.instance
        .collection('family_quiz_answers')
        .doc(familyName)
        .set({
      'answered': true,
      'isCorrect': isCorrect,
      'dateAnswered': DateTime.now(),
    });

    if (isCorrect) {
      await FirebaseFirestore.instance
          .collection('families')
          .doc(familyName)
          .update({'correctAnswersCount': FieldValue.increment(1)});
      setState(() {
        correctAnswersCount++;
        isAnswerCorrect = true;
        hasAnswered = true;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("إجابة صحيحة!")));
    } else {
      setState(() {
        hasAnswered = true;
        isAnswerCorrect = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("إجابة خاطئة، حاول غدًا!")));
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("سؤال اليوم"),
          backgroundColor: AppColors.darkBlue,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: familyName.isEmpty
                ? const CircularProgressIndicator()
                : hasAnswered
                    ? const Center(
                        child: Text(
                          "✅ لقد أجبت على سؤال اليوم. عد غدًا لسؤال جديد!",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : value.todeyQuestion == null
                        ? const CircularProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.todeyQuestion!.question,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ...value.todeyQuestion!.options
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                String optionKey =
                                    String.fromCharCode(65 + entry.key);
                                bool isSelected = optionKey == selectedAnswer;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswer = optionKey;
                                    });
                                  },
                                  child: QuizOptionWidget(
                                    option: entry.value,
                                    isSelected: isSelected,
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitAnswer,
                                  child: Text("إرسال الإجابة",
                                      style: TextStyle(fontSize: 18)),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    primary: AppColors.darkBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
          ),
        ),
      ),
    );
  }
}
