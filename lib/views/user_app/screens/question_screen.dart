import 'dart:async';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/views/user_app/widgets/opetion_widget.dart';
import 'package:provider/provider.dart';

class StartQuizPage extends StatefulWidget {
  final CompetitionModel competitionModel;
  final List<QuestionModel> questions;
  final bool function;

  const StartQuizPage(this.competitionModel, this.questions, this.function,
      {super.key});

  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {
  late PageController pageController;
  late Timer _timer;
  late ValueNotifier<int> _remainingTime;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _remainingTime = ValueNotifier<int>(widget.competitionModel.timer * 60);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.value > 0) {
        _remainingTime.value--;
      } else {
        _timer.cancel();
        _submitQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    pageController.dispose();
    _remainingTime.dispose();
    super.dispose();
  }

  void _submitQuiz() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.calculateScore();
    quizProvider.saveResult(
      widget.competitionModel.title,
      widget.competitionModel.questionCount,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("انتهى الوقت!"),
        content: Text("نتيجتك في المسابقة هي ${quizProvider.calculateScore()}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRouter.userhome, (route) => false);
            },
            child: const Text("موافق"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: const Text("المسابقة"),
        ),
        body: value.userAnser
            ? const Center(
                child: Text(
                  "✅لقد أجبت على هذه المسابقة !",
                  style: TextStyle(fontSize: 18, color: AppColors.darkBlue),
                ),
              )
            : PageView.builder(
                controller: pageController,
                itemCount: widget.competitionModel.questionCount,
                itemBuilder: (context, index) {
                  String buttonText =
                      index == widget.competitionModel.questionCount - 1
                          ? "تسليم المسابقة"
                          : "السؤال التالي";

                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'السؤال ${index + 1} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkBlue,
                                        fontSize: 28),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.darkBlue,
                                      AppColors.primaryGreen,
                                      AppColors.secondaryGreen
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                value.questions2[index].question,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ...List.generate(
                              4,
                              (i) => GestureDetector(
                                onTap: () {
                                  value.selectAnswer(
                                      index, String.fromCharCode(65 + i));
                                  value.calculateScore();
                                },
                                child: QuizOptionWidget(
                                  option: widget.questions[index].options[i],
                                  isSelected: value.getSelectedAnswer(index) ==
                                      String.fromCharCode(65 + i),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (index <
                                      widget.competitionModel.questionCount -
                                          1) {
                                    pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut);
                                  } else {
                                    _submitQuiz();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.darkBlue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(buttonText),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TimerWidget(remainingTime: _remainingTime),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final ValueNotifier<int> remainingTime;

  const TimerWidget({super.key, required this.remainingTime});

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: remainingTime,
      builder: (context, time, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: AppColors.darkBlue),
              const SizedBox(width: 10),
              Text(
                "الوقت المتبقي: ${_formatTime(time)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
