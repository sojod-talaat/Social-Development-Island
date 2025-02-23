import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';
import 'package:island_social_development/core/services/location_service.dart';
import 'package:island_social_development/core/services/pray_time_services.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class PrayerTimesPage extends StatefulWidget {
  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  Map<String, dynamic>? prayerTimes;
  bool isLoading = true;

  final List<Map<String, String>> selectedPrayers = [
    {"name": "الفجر", "key": "Fajr"},
    {"name": "الشروق", "key": "Sunrise"},
    {"name": "الظهر", "key": "Dhuhr"},
    {"name": "العصر", "key": "Asr"},
    {"name": "المغرب", "key": "Maghrib"},
    {"name": "العشاء", "key": "Isha"},
  ];

  @override
  void initState() {
    super.initState();
    _loadCachedPrayerTimes();
  }

  Future<void> _loadCachedPrayerTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('prayer_times');
    String? lastUpdated = prefs.getString('last_updated');

    if (cachedData != null && lastUpdated != null) {
      DateTime lastUpdateTime = DateTime.parse(lastUpdated);
      DateTime now = DateTime.now();

      if (now.difference(lastUpdateTime).inHours < 24) {
        setState(() {
          prayerTimes = json.decode(cachedData);
          isLoading = false;
        });
        return;
      }
    }
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      final times = await PrayerTimesService.fetchPrayerTimes(
          position.latitude, position.longitude);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('prayer_times', json.encode(times));
      prefs.setString('last_updated', DateTime.now().toIso8601String());

      setState(() {
        prayerTimes = times;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(String time) {
    try {
      final inputFormat = DateFormat("HH:mm");
      final outputFormat = DateFormat("h:mm a");
      final dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider value, Widget? child) =>
          Scaffold(
        appBar: AppBar(
          title: const Text("مواقيت الصلاة"),
          centerTitle: true,
          backgroundColor: AppColors.darkBlue,
          elevation: 4,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : prayerTimes == null
                ? const Center(child: Text("تعذر جلب البيانات"))
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.secondaryGreen,
                          AppColors.darkBlue,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        children: selectedPrayers.map((prayer) {
                          return _buildPrayerCard(
                            prayer["name"]!,
                            formatTime(prayerTimes![prayer["key"]!]!),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildPrayerCard(String prayerName, String prayerTime) {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: AppColors.primaryGreen,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          trailing:
              const Icon(Icons.access_time, color: Colors.white, size: 30),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(
              prayerName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              prayerTime,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ]),
        ),
      ),
    );
  }
}
