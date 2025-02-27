import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/models/question_model.dart';

class EditQuestionScreen extends StatefulWidget {
  final QuestionModel question;
  String quizId;

  EditQuestionScreen({super.key, required this.question, required this.quizId});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionsControllers;
  late String _correctAnswer;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _optionsControllers = widget.question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    _correctAnswer = widget.question.correctAnswer;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: const Text("تعديل السؤال")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: "نص السؤال"),
              ),
              const SizedBox(height: 10),
              ...List.generate(4, (index) {
                return TextField(
                  controller: _optionsControllers[index],
                  decoration: InputDecoration(labelText: "الخيار ${index + 1}"),
                );
              }),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _correctAnswer,
                onChanged: (newValue) {
                  setState(() {
                    _correctAnswer = newValue!;
                  });
                },
                items:
                    ["A", "B", "C", "D"].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text("الإجابة الصحيحة: $value"),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedQuestion = QuestionModel(
                    id: widget.question.id,
                    question: _questionController.text,
                    options: _optionsControllers
                        .map((controller) => controller.text)
                        .toList(),
                    correctAnswer: _correctAnswer,
                  );
                  value.updateQuestion(
                      widget.quizId, widget.question.id, updatedQuestion);

                  Navigator.pop(context);
                },
                child: const Text("حفظ التعديلات"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
