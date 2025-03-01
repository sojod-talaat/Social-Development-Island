import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/controllers/auth_controller.dart';
import 'package:island_social_development/controllers/firestore_controller.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController famNam = TextEditingController();
  TextEditingController loginemailController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();
  TextEditingController resetpasswordemail = TextEditingController();
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

  void submitSignUpForm(
      BuildContext context, GlobalKey<FormState> key, String type) async {
    if (key.currentState!.validate()) {
      await signup(context, type);
      signUpclear();
    } else {
      SignUpautoValidate = false;
      notifyListeners();
    }
  }

  signup(BuildContext context, String type) async {
    UserCredential? userCredential = await AuthController.authhelper
        .signUp(emailController.text, passwordController.text, context);

    int age = (selectedStage == "المرحلة الابتدائية ") ? 12 : 13;

    if (userCredential == null || userCredential.user == null) {
      print("⚠️ فشل إنشاء المستخدم");
      return;
    }

    String userId = userCredential.user!.uid;

    if (type == "1") {
      // 🔥 إذا كان مستخدم عادي
      UserModel user = UserModel(
        id: userId,
        name: nameController.text,
        email: emailController.text,
        age: age,
        userType: "user", // ✅ تخزينه كمستخدم عادي
      );

      await FireStoreController.fireStoreHelper.saveUserToFirestore(user);
      await prefsHelper.saveUserModel(user);
    } else {
      // 🔥 إذا كان Family
      String familyName = famNam.text;

      // ✅ حفظ المستخدم في `users` ولكن بنوع `family`
      UserModel familyUser = UserModel(
        id: userId,
        name: nameController.text,
        email: emailController.text,
        age: age,
        userType: "family", // ✅ نوع المستخدم "family"
      );

      await FireStoreController.fireStoreHelper.saveUserToFirestore(familyUser);
      await prefsHelper.saveUserModel(familyUser);

      // ✅ حفظ العائلة في `families` مع بيانات إضافية
      await FirebaseFirestore.instance
          .collection('families')
          .doc(familyName)
          .set({
        'correctAnswersCount': 0,
        'name': familyName,
        'familyId': userId, // ربط الحساب بمؤسس العائلة
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('family_quiz_answers')
          .doc(familyName)
          .set({});
      // ✅ حفظ اسم العائلة محليًا
      prefsHelper.saveFamName(familyName);
    }

    // 🔥 تحميل بيانات المستخدم بعد التسجيل
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> resetPassword(String email, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.pushReplacementNamed(context, AppRouter.confirmationPage);
    } catch (e) {
      _errorMessage = "حدث خطأ: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
