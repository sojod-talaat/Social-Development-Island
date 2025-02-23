import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التحقق مما إذا كان تحديد الموقع مفعّلًا
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null; // الخدمة غير مفعّلة
    }

    // التحقق من الأذونات
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return null; // تم رفض الإذن نهائيًا
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
