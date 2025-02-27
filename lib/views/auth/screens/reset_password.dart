import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        appBar: AppBar(title: const Text("نسيت كلمة المرور")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: authProvider.resetpasswordemail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "البريد الإلكتروني",
                  border: OutlineInputBorder(),
                ),
              ),
              if (authProvider.errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        await authProvider.resetPassword(
                            authProvider.resetpasswordemail.text, context);
                      },
                      child: const Text("إرسال رابط إعادة التعيين"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
