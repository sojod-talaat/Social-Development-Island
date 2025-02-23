class QuestionModel {
  String id;
  String question;
  List<String> options;
  String correctAnswer;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  // تحويل السؤال إلى JSON لحفظه في Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "question": question,
      "options": options,
      "correctAnswer": correctAnswer,
    };
  }

  // إنشاء كائن `QuestionModel` من JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["id"],
      question: json["question"],
      options: List<String>.from(json["options"]),
      correctAnswer: json["correctAnswer"],
    );
  }
}
