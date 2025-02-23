class FamilyStatsModel {
  String familyName;
  int correctAnswersCount;

  FamilyStatsModel({
    required this.familyName,
    required this.correctAnswersCount,
  });

  // تحويل من JSON إلى كائن Dart
  factory FamilyStatsModel.fromJson(Map<String, dynamic> map) {
    return FamilyStatsModel(
      familyName: map['name'],
      correctAnswersCount: map['correctAnswersCount'],
    );
  }

  // تحويل من كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'name': familyName,
      'correctAnswersCount': correctAnswersCount,
    };
  }
}
