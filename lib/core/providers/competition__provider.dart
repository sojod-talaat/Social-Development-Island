import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _competitions = [];
  List<Map<String, dynamic>> get competitions => _competitions;

  Future<void> fetchCompetitions(String category) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('competitions')
          .doc(category)
          .collection("general")
          .get();

      _competitions = snapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      notifyListeners();
    } catch (e) {
      print("❌ Error fetching competitions: $e");
    }
  }
}
