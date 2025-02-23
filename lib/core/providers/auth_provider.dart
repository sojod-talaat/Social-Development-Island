import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/auth_controller.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController famNam = TextEditingController();
  TextEditingController loginemailController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();

  bool SignInautoValidate = false;
  bool SignUpautoValidate = false;
  UserModel? currentUser;
  void signInclear() {
    nameController.clear();
    passwordController.clear();
    ageController.clear();
    emailController.clear();
  }

  void signUpclear() {
    nameController.clear();
    passwordController.clear();
    ageController.clear();
    emailController.clear();
  }

// متغير لتخزين المرحلة الدراسية
  String? _selectedStage;

  String? get selectedStage => _selectedStage;

  set selectedStage(String? value) {
    _selectedStage = value;
    notifyListeners(); // Notify listeners when the value changes
  }

  // الuserحصول على نسخة Singleton من SharedPreferencesHelper
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();

  void submitSignInForm(BuildContext context, GlobalKey<FormState> key) {
    if (key.currentState!.validate()) {
      signIn(context);
      signInclear();
    } else {
      SignInautoValidate = false;
      notifyListeners();
    }
  }

  void submitSignUpForm(BuildContext context, GlobalKey<FormState> key) {
    if (key.currentState!.validate()) {
      signup(context);
      signUpclear();
    } else {
      SignUpautoValidate = false;
      notifyListeners();
    }
  }

  signup(BuildContext context) async {
    UserCredential? usercreditanl = await AuthController.authhelper
        .signUp(emailController.text, passwordController.text, context);
    int age = 0;
    if (selectedStage == "المرحلة الابتدائية ") {
      age = 12;
    } else {
      age = 13;
    }
    UserModel user = UserModel(
        id: usercreditanl!.user!.uid,
        name: nameController.text,
        email: emailController.text,
        age: age);

    await FireStoreController.fireStoreHelper.saveUserToFirestore(
      user,
    );
    prefsHelper.saveFamName(famNam.text);

    await FirebaseFirestore.instance
        .collection('families')
        .doc(famNam.text)
        .set({'correctAnswersCount': 0, 'name': famNam.text},
            SetOptions(merge: true));
    await prefsHelper.saveUserModel(user);
    //****************************************************** */
    currentUser = await AuthController.authhelper.loadUser(context);
  }

  signIn(BuildContext context) async {
    await AuthController.authhelper.signInAndRedirect(
        loginemailController.text, loginpasswordController.text, context);
  }

  /////////////////////////////////////////////////////change password visibilty
  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners(); // ✅ تحديث الواجهة
  }

  // دالة للتحقق من صحة الإيميل
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال البريد الالكتروني ';
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return 'يرجى ادخال بريد الكتروني صالح';
    }
    return null;
  }

  // دالة للتحقق من صحة الاسم
  String? validateName(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال الاسم !';
    }
    if (value.length < 3) {
      return 'يجب ان يحتوى الاسم على 3 أحرف على الأقل ';
    }
    return null;
  }

  // دالة للتحقق من العمر
  String? validateAge(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال العمر';
    }
    int? age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'يجب أن يكون العمر صحيحا ';
    }
    return null;
  }

  // دالة للتحقق من كلمة المرور
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'يرجى ادخال كلمة مرور ';
    }
    if (value.length < 3) {
      return 'كلمة المرور يجب أن تحتوي على 5 أحرف على الاقل';
    }
    return null;
  }

  String? FamName(String value) {
    if (value.isEmpty) {
      return "يجب ادخال اسم رب الاسرة ";
    }

    return null;
  }
}
