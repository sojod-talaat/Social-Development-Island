import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true, // زر الرجوع اختياري
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null, // لا يظهر زر الرجوع إذا كان `showBackButton = false`
      actions: actions, // يمكن إضافة أيقونات إضافية
      elevation: 4, // ظل خفيف للأب بار // يمكن تغييره بسهولة
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
