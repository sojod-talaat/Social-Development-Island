import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/app_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class DouratScreen extends StatelessWidget {
  const DouratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (context, appProvider, child) => SafeArea(
              child: Scaffold(
                drawer: const AppDrawer(),
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text('الدورات'),
                  backgroundColor: AppColors.darkBlue,
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/dourat.jpg"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: appProvider.dourat.map((doura) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              elevation: 5, // لإضافة ظل جميل للكارد
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doura.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const Divider(),
                                    Text(
                                      "📅 تاريخ البدء: ${doura.startDate}",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "📅 تاريخ الانتهاء: ${doura.endDate}",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
