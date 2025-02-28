class UserModel {
  String? id;
  String? email;
  String? name;
  int? age;
  String? userType;
  UserModel(
      {this.id,
      required this.email,
      required this.name,
      required this.age,
      required this.userType});

  // Constructor from JSON
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    email = json["email"];
    name = json["name"];
    age = json["age"];
    userType = json["usertype"];
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "age": age,
      "usertype": userType
    };
  }
}
