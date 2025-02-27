class QuizModel {
  final String quizName;
  final DateTime startDate;

  QuizModel({
    required this.quizName,
    required this.startDate,
  });

  factory QuizModel.fromJson(String id, Map<String, dynamic> json) {
    return QuizModel(
      quizName: json['name'] ?? 'بدون اسم',
      startDate: DateTime.parse(json['startDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {"name": quizName, "startDate": startDate.toIso8601String()};
  }
}
