class DouraTahfizModel {
  String? id;
  String name;
  String startDate;
  String endDate;

  DouraTahfizModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory DouraTahfizModel.fromJson(Map<String, dynamic> map) {
    return DouraTahfizModel(
      id: map['id'],
      name: map['name'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }
}
