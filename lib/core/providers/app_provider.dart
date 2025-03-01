import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/models/doura_tahfiz.dart';

class AppProvider with ChangeNotifier {
  AppProvider() {
    getAllDourat();
    // _fetchLocation();
  }
  //متغيرات دورات التحفيظ
  TextEditingController douraName = TextEditingController();
  TextEditingController douraStartDate = TextEditingController();
  TextEditingController douraEndDate = TextEditingController();
  List<DouraTahfizModel> dourat = [];
  String startDate = '';
  String endDate = '';
  //Add doura
  addDouraTahfiz() {
    DouraTahfizModel doura = DouraTahfizModel(
        name: douraName.text,
        startDate: douraStartDate.text,
        endDate: douraEndDate.text);
    FireStoreController.fireStoreHelper.addDouraToFireStor(doura);
    doura.id = doura.id;
    getAllDourat();

    notifyListeners();
  }

  //clear textformfields
  void disposeDouraFields() {
    douraName.clear();
    douraStartDate.clear();
    douraEndDate.clear();
  }

  //view dourat
  getAllDourat() async {
    dourat =
        await FireStoreController.fireStoreHelper.getAllDouratFromFireStore();
    notifyListeners();
  }

  //دالة التحقق من الدورة
  String? validateDouraName(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال اسم الدورة';
    }
    return null;
  }

  String? validateDouraStartDate(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال تاريخ بدء الحلقة ';
    }
    return null;
  }

  String? validateDouraEndDate(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال تاريخ انتهاء الحلقة ';
    }
    return null;
  }

  bool valideteDates() {
    if (douraEndDate.text == douraStartDate.text) {
      return false;
    } else {
      return true;
    }
  }

  bool validateForm(GlobalKey<FormState> key) {
    if (key.currentState!.validate()) {
      return true;
    }
    notifyListeners(); // تحديث الواجهة إذا كان هناك خطأ
    return false;
  }
}
