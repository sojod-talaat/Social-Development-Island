import 'package:island_social_development/models/question_model.dart';

class CompetitionModel {
  String id;
  String title;
  int questionCount;
  int timer;
  List<QuestionModel> questions; // قائمة تحتوي على الأسئلة

  CompetitionModel(
      {required this.id,
      required this.title,
      required this.questionCount,
      required this.questions,
      required this.timer});

  // تحويل الكائن إلى JSON لحفظه في Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "questionCount": questionCount,
      "timer": timer,
      "questions":
          questions.map((q) => q.toJson()).toList(), // تحويل كل سؤال إلى JSON
    };
  }

  // إنشاء كائن `CompetitionModel` من JSON
  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json["id"],
      timer: json["timer"],
      title: json["title"],
      questionCount: json["questionCount"],
      questions: (json["questions"] as List<dynamic>)
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}
