import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.label,
    this.onChange,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.focusNode,
    this.validator,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final Widget? label;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      focusNode: focusNode,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: label,
        prefixIcon: prefix,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        suffixIcon: suffix,
        hintText: hint,
      ),
    );
  }
}
