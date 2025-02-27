import 'package:flutter/material.dart';
import 'package:island_social_development/models/question_model.dart';
import 'package:island_social_development/views/admin_app/Family/edit_question.dart';
import 'package:provider/provider.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
// استيراد صفحة التعديل

class AllQuestionsScreen extends StatefulWidget {
  List<QuestionModel> Questions;
  AllQuestionsScreen({super.key, required this.Questions});

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<AllQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الأسئلة",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.darkBlue,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.quizesQuestion.isEmpty) {
            return const Center(child: Text("لا يوجد أسئلة حتى الآن"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: quizProvider.quizesQuestion.length,
            itemBuilder: (context, index) {
              final question = quizProvider.quizesQuestion[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟢 نص السؤال
                      Text(
                        "السؤال ${index + 1}: ${question.question}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 🟢 عرض جميع الخيارات مع تمييز الصحيح
                      _buildAnswerOption(
                          "A", question.options[0], question.correctAnswer),
                      _buildAnswerOption(
                          "B", question.options[1], question.correctAnswer),
                      _buildAnswerOption(
                          "C", question.options[2], question.correctAnswer),
                      _buildAnswerOption(
                          "D", question.options[3], question.correctAnswer),

                      const SizedBox(height: 10),

                      // 🟢 أزرار الحذف والتعديل
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 🔄 زر التعديل
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EditQuestionScreen(
                              //         quizId: widget.quizId,
                              //         question: question),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🎨 دالة تعرض الإجابات مع تلوين الإجابة الصحيحة
  Widget _buildAnswerOption(String label, String answer, String correctAnswer) {
    bool isCorrect = label.toLowerCase() == correctAnswer.toLowerCase();
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isCorrect ? Colors.green : Colors.grey),
        ),
        child: Text(
          "$label) $answer",
          style: TextStyle(
            fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
            color: isCorrect ? Colors.green[900] : Colors.black,
          ),
        ),
      ),
    );
  }

  /// 🗑️ دالة حذف السؤال من Firestore
}
