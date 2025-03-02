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

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> key = GlobalKey<FormState>();
    var local = AppLocalizations.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Form(
                key: key,
                autovalidateMode: authProvider.SignInautoValidate
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
                      height: 12,
                    ),
                    Text(local.translate('title'),
                        style: Styles.textStyle20.copyWith(
                          color: AppColors.darkBlue,
                          fontSize: 20,
                        )),
                    Row(
                      children: [
                        Text(local.translate('signin'),
                            style: Styles.textStyle20.copyWith(
                              color: AppColors.darkBlue,
                              fontSize: 15,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.loginemailController.text = value;
                        authProvider.validateEmail(value);
                      },
                      controller: authProvider.loginemailController,
                      prefix: const Icon(Icons.person_outline),
                      hint: "البريد الالكتروني",
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          authProvider.validateEmail(value ?? 'test'),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      onChange: (value) {
                        authProvider.loginpasswordController.text = value;
                        authProvider.validatePassword(value);
                      },
                      validator: (value) =>
                          authProvider.validatePassword(value ?? 'test'),
                      controller: authProvider.loginpasswordController,
                      keyboardType: TextInputType.name,
                      obscureText: authProvider.isPasswordVisible,
                      prefix: const Icon(Icons.lock_outline_rounded),
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
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          authProvider.submitSignInForm(context, key);
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
                        child: Text(local.translate('signintext')),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: local.translate('signinterm'),
                            style: Theme.of(context).textTheme.button,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, AppRouter.signup);
                              },
                            text: local.translate('signinterm2'),
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: AppColors.darkBlue),
                          ),
                        ])),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "هل نسيت كلمة المرور؟",
                            style: Theme.of(context).textTheme.button,
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, AppRouter.forgetPassword);
                              },
                            text: "انقر لاستعادتها",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: AppColors.darkBlue),
                          ),
                        ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
