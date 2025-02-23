import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/views/user_app/widgets/opetion_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';

// ignore: must_be_immutable
class FamQuestionScreen extends StatefulWidget {
  QuestionModel todayQuestion;
  FamQuestionScreen({super.key, required this.todayQuestion});

  @override
  _FamQuestionScreenState createState() => _FamQuestionScreenState();
}

class _FamQuestionScreenState extends State<FamQuestionScreen> {
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  int correctAnswersCount = 0;
  String? selectedAnswer; // رمز الإجابة
  bool hasAnswered = false;
  bool isAnswerWrong = false;
  String familyName = '';
  DateTime? lastAnsweredDate;

  @override
  void initState() {
    super.initState();
    _loadFamilyData();
  }

  Future<void> _loadFamilyData() async {
    familyName = await prefsHelper.getFamName();
    if (familyName.isNotEmpty) {
      await _fetchCorrectAnswersCount();
      await _checkIfAnswered();
      await _checkIfNewDay();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("اسم الأسرة غير موجود. يرجى التسجيل أولاً.")),
      );
    }
  }

  Future<void> _fetchCorrectAnswersCount() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('families')
        .doc(familyName)
        .get();
    if (doc.exists && doc['correctAnswersCount'] != null) {
      setState(() {
        correctAnswersCount = doc['correctAnswersCount'];
      });
    }
  }

  Future<void> _checkIfAnswered() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('family_quiz_answers')
        .doc(familyName)
        .get();
    setState(() {
      hasAnswered = doc.exists;
      if (hasAnswered) {
        lastAnsweredDate = doc['dateAnswered']?.toDate();
      }
    });
  }

  Future<void> _checkIfNewDay() async {
    if (lastAnsweredDate != null) {
      DateTime currentDate = DateTime.now();
      if (currentDate.day != lastAnsweredDate!.day ||
          currentDate.month != lastAnsweredDate!.month ||
          currentDate.year != lastAnsweredDate!.year) {
        await FirebaseFirestore.instance
            .collection('family_quiz_answers')
            .doc(familyName)
            .update({'answered': false, 'dateAnswered': currentDate});
        setState(() {
          hasAnswered = false;
        });
      }
    }
  }

  Future<void> _submitAnswer() async {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("الرجاء اختيار إجابة")));
      return;
    }

    // مقارنة الإجابة المختارة مع الإجابة الصحيحة (المخزنة كرمز)
    bool isCorrect = widget.todayQuestion.correctAnswer == selectedAnswer;
    if (isCorrect) {
      await FirebaseFirestore.instance
          .collection('family_quiz_answers')
          .doc(familyName)
          .set({
        'answered': true,
        'dateAnswered': DateTime.now(),
      });
      await FirebaseFirestore.instance
          .collection('families')
          .doc(familyName)
          .update({'correctAnswersCount': FieldValue.increment(1)});
      setState(() {
        correctAnswersCount++;
        hasAnswered = true;
        isAnswerWrong = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("إجابة صحيحة!")));
      Navigator.pop(context);
    } else {
      setState(() {
        isAnswerWrong = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("إجابة خاطئة، حاول غدًا!")));
      Navigator.pushNamed(context, AppRouter.userhome);
    }
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
                ? const Center(child: CircularProgressIndicator())
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
                                String optionKey = String.fromCharCode(
                                    65 + entry.key); // "a", "b", "c", "d"
                                bool isSelected = optionKey == selectedAnswer;
                                return GestureDetector(
                                  onTap: isAnswerWrong
                                      ? null
                                      : () {
                                          print(optionKey);
                                          setState(() {
                                            selectedAnswer =
                                                optionKey; // تخزين الرمز
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
                                  onPressed:
                                      isAnswerWrong ? null : _submitAnswer,
                                  child: Text(
                                    "إرسال الإجابة",
                                    style: TextStyle(fontSize: 18),
                                  ),
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
                              const SizedBox(height: 20),
                              isAnswerWrong
                                  ? const Text(
                                      "إجابة خاطئة، حاول غدًا!",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 16),
                                    )
                                  : Container(),
                            ],
                          ),
          ),
        ),
      ),
    );
  }
}
