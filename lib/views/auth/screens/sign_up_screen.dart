// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/localization/app_localization.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/theme/app_style.dart';
import 'package:island_social_development/core/utils/app_assets.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  GlobalKey<FormState> userKey = GlobalKey<FormState>();
  GlobalKey<FormState> famKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var local = AppLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => Scaffold(
          appBar: AppBar(
            title: Text(local.translate('signup')),
            bottom: const TabBar(
              labelColor: AppColors.whiteColor,
              dividerColor: AppColors.darkBlue,
              tabs: [
                Tab(text: "تسجيل الطلاب "),
                Tab(text: "تسجيل رب الاسرة "),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Form(
                      key: userKey,
                      autovalidateMode: authProvider.SignUpautoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(children: [
                        Image.asset(
                          AppAssets.logoImage,
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          local.translate('title'),
                          style: Styles.textStyle20.copyWith(
                            color: AppColors.darkBlue,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          onChange: (value) {
                            authProvider.nameController.text = value;
                          },
                          controller: authProvider.nameController,
                          keyboardType: TextInputType.name,
                          prefix: const Icon(Icons.person_2_outlined),
                          validator: (value) =>
                              authProvider.validateName(value ?? ''),
                          hint: local.translate("username"),
                          textInputAction: TextInputAction.done,
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
                        DropdownButtonFormField<String>(
                          value: authProvider.selectedStage,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.school),
                            hintText: "المرحلة الدراسية ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: '1',
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
                              authProvider.submitSignUpForm(
                                  context, userKey, "1");
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(AppColors.darkBlue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(local.translate('Register')),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                      ])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Form(
                    key: famKey,
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
                        const SizedBox(height: 10),
                        Text(
                          local.translate('title'),
                          style: Styles.textStyle20.copyWith(
                            color: AppColors.darkBlue,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          onChange: (value) {
                            authProvider.emailController.text = value;
                          },
                          controller: authProvider.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.alternate_email_rounded),
                          hint: " البريد الالكتروني  ",
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              authProvider.validateEmail(value ?? ''),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          onChange: (value) {
                            authProvider.famNam.text = value;
                          },
                          controller: authProvider.famNam,
                          keyboardType: TextInputType.name,
                          prefix: const Icon(Icons.family_restroom),
                          hint: "اسم رب الاسرة ",
                          textInputAction: TextInputAction.done,
                          validator: (value) =>
                              authProvider.FamName(value ?? ''),
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
                              authProvider.submitSignUpForm(
                                  context, famKey, "2");
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(AppColors.darkBlue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(local.translate('Register')),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
            ],
          ),
        ),
      ),
    );
  }
}
