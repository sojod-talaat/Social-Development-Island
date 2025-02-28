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

  // ///////////////////////////////////////////////////////////////الموقع
  // static Future<Position?> getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // 1️⃣ التحقق من تفعيل خدمة الموقع
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     print("خدمة الموقع غير مفعلة.");
  //     return null;
  //   }

  //   // 2️⃣ التحقق من الأذونات
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       print("تم رفض إذن الموقع.");
  //       return null;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     print("تم رفض إذن الموقع نهائيًا.");
  //     return null;
  //   }

  //   // 3️⃣ جلب الموقع الحالي
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  // double latitude = 0.0;
  // double longitude = 0.0;
  // Position? position;
  // Future<void> _fetchLocation() async {
  //   position = await getCurrentLocation();
  //   if (position != null) {
  //     latitude = position!.latitude;
  //     longitude = position!.longitude;
  //     notifyListeners();
  //   }
  // }

  // ///////////////////////////////////////////////////////////واعيد الصلاة
  // PrayerTimes prayerTimes = PrayerTimes(
  //   coordinates: Coordinates(31.5, 34.46667),
  //   calculationParameters: CalculationMethod.karachi(),
  //   date: DateTime.now(),
  //   // Specify the desired date
  // );

//////////////////////////////////////////////////////////////////////////المسابقات
}
