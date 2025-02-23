import 'package:flutter/material.dart';
import 'package:island_social_development/core/utils/app_color.dart';

class SnakBarWidget {
  static void show(BuildContext context, String message,
      {Color backgroundColor = Colors.white}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontSize: 16, color: AppColors.blackColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
