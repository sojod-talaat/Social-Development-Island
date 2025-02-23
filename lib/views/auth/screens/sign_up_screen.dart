import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/localization/app_localization.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/theme/app_style.dart';
import 'package:island_social_development/core/utils/app_assets.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context);
    GlobalKey<FormState> key = GlobalKey<FormState>();
    return Consumer<AuthProvider>(
      builder:
          (BuildContext context, AuthProvider authProvider, Widget? child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Form(
                key: key,
                autovalidateMode: authProvider.SignUpautoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.logoImage,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      local.translate('title'),
                      style: Styles.textStyle20.copyWith(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          local.translate('signup'),
                          style: Styles.textStyle20.copyWith(
                            color: AppColors.darkBlue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.nameController.text = value;
                      },
                      controller: authProvider.nameController,
                      prefix: const Icon(Icons.person_outline),
                      hint: local.translate('username'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          authProvider.validateName(value ?? ''),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.emailController.text = value;
                      },
                      controller: authProvider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.alternate_email_rounded),
                      hint: local.translate('Email Address'),
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          authProvider.validateEmail(value ?? ''),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.famNam.text = value;
                      },
                      controller: authProvider.famNam,
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.family_restroom),
                      hint: "اسم رب الاسرة ",
                      textInputAction: TextInputAction.done,
                      validator: (value) => authProvider.FamName(value ?? ''),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: authProvider.selectedStage,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.school),
                        hintText: "المرحلة الدراسية ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'المرحلة الابتدائية',
                          child: Text("المرحلة الابتدائية"),
                        ),
                        DropdownMenuItem(
                          value: 'المرحلة المتوسطة',
                          child: Text("المرحلة المتوسطة"),
                        ),
                        DropdownMenuItem(
                          value: 'المرحلة الثانوية ',
                          child: Text("المرحلة الثانوية"),
                        ),
                        DropdownMenuItem(
                          value: 'المرحلة الجامعية',
                          child: Text("المرحلة الجامعية"),
                        ),
                      ],
                      onChanged: (value) {
                        authProvider.selectedStage = value;
                      },
                      validator: (value) =>
                          value == null ? "اختر المرحلة الدراسية" : null,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.passwordController.text = value;
                      },
                      controller: authProvider.passwordController,
                      keyboardType: TextInputType.name,
                      obscureText: authProvider.isPasswordVisible,
                      prefix: const Icon(Icons.lock_outline_rounded),
                      validator: (value) =>
                          authProvider.validatePassword(value ?? ''),
                      suffix: IconButton(
                        onPressed: () {
                          authProvider.togglePasswordVisibility();
                        },
                        icon: Icon(
                          authProvider.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      hint: local.translate("Password"),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () async {
                          authProvider.submitSignUpForm(context, key);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.darkBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Text(local.translate('Register')),
                      ),
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: local.translate('signupterm'),
                                style: Theme.of(context).textTheme.button,
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, AppRouter.signin);
                                  },
                                text: local.translate('signupterm2'),
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(color: AppColors.darkBlue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
