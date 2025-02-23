import 'dart:convert';
import 'package:http/http.dart' as http;

class PrayerTimesService {
  static Future<Map<String, dynamic>?> fetchPrayerTimes(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['timings'];
    } else {
      return null; // فشل في جلب البيانات
    }
  }
}
