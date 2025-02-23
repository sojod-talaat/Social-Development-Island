import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:island_social_development/core/routing/app_router.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/user_model.dart';
import 'package:island_social_development/views/auth/widgets/snak_bar.dart';

class AuthController {
  AuthController._();
  static AuthController authhelper = AuthController._();
  final FirebaseAuth auth = FirebaseAuth.instance;
  // الحصول على نسخة Singleton من SharedPreferencesHelper
  SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
//////////////////////////////////////////////////////////////////تسجيل الاشتراك
  Future<UserCredential?> signUp(
      String email, String password, BuildContext context) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
// ignore: use_build_context_synchronously
      SnakBarWidget.show(context, "تم تسجيل الحساب بنجاح",
          backgroundColor: AppColors.darkBlue);
      return credential;
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          "حدث خطأ غير متوقع، حاول مرة أخرى."; // رسالة افتراضية

      if (e.code == 'weak-password') {
        errorMessage = "كلمة المرور ضعيفة جدًا، يرجى اختيار كلمة أقوى.";
        // ignore: use_build_context_synchronously
        SnakBarWidget.show(context, errorMessage);
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "البريد الإلكتروني مستخدم بالفعل، جرب بريدًا آخر.";
        // ignore: use_build_context_synchronously
        SnakBarWidget.show(context, errorMessage);
      } else if (e.code == 'invalid-email') {
        errorMessage = "البريد الإلكتروني غير صالح.";
        // ignore: use_build_context_synchronously
        SnakBarWidget.show(context, errorMessage);
      }
    }
    return null;
  }

  Future<UserCredential?> signInAndRedirect(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: use_build_context_synchronously
      SnakBarWidget.show(context, "تم تسجيل دخولك بنجاح",
          backgroundColor: AppColors.darkBlue);
      // ignore: use_build_context_synchronously
      checkUserStatus(context);
      return userCredential;
      //******************************************************************* */
    } on FirebaseAuthException catch (e) {
      SnakBarWidget.show(context, 'Error: ${e.message}');
    }
    return null;
  }

//////////////////////////////////////////////////////////////////////////التحقق
  void checkUserStatus(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      auth.authStateChanges().listen((user) {
        if (user != null) {
          loadUser(context);
        } else {
          Navigator.pushNamed(context, AppRouter.signup);
        }
      });
    });
  }

  ///////////////////////////////////////////////////////ارجاع المستخدم الحالي
  Future<UserModel?> loadUser(BuildContext context) async {
    final userLocal = await prefsHelper.getUserModel();

    if (userLocal != null) {
      // 🔥 تأجيل التنقل حتى يتم بناء الـ Widget بالكامل
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          if (userLocal.email == "fahadj1p@gmail.com") {
            Navigator.pushNamed(context, AppRouter.adminhome);
          } else {
            Navigator.pushNamed(context, AppRouter.userhome);
          }
        }
      });
      return userLocal;
    }

    // 🔥 جلب بيانات المستخدم من FirebaseAuth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 🔥 جلب بيانات المستخدم من Firestore
      final userModel = await fetchUserFromFirestore(user.uid);
      if (userModel != null) {
        await prefsHelper.saveUserModel(userModel); // 🔥 حفظ المستخدم محليًا

        // 🔥 تأجيل التنقل بعد اكتمال بناء الواجهة
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            if (userModel.email == "fahadj1p@gmail.com") {
              Navigator.pushReplacementNamed(context, AppRouter.adminhome);
            } else {
              Navigator.pushReplacementNamed(context, AppRouter.userhome);
            }
          }
        });

        return userModel;
      }
    }

    return null; // 🔴 في حال لم يتم العثور على بيانات المستخدم
  }

  ///////////////////////////////////
  Future<UserModel?> fetchUserFromFirestore(String id) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      if (userDoc.exists) {
        // تحويل البيانات إلى نموذج UserModel
        UserModel user =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

        // حفظ بيانات المستخدم في SharedPreferences
        await prefsHelper.saveUserModel(user);

        // طباعة اسم المستخدم (لأغراض التصحيح)
        print(user.name);

        // إرجاع بيانات المستخدم
        return user;
      } else {
        // إذا لم يتم العثور على المستخدم، إرجاع null
        print("No user found with email: $id");
        return null;
      }
    } catch (e) {
      // طباعة الخطأ وإعادة رمي الاستثناء إذا لزم الأمر
      print("Error fetching user: $e");
      rethrow; // إعادة رمي الاستثناء إذا كنت تريد معالجته في مكان آخر
    }
  }

  ///////////////////////////////////////////////////////////////////////signout
  dynamic signout() async {
    await prefsHelper.removeUser();
    await auth.signOut();
  }
}
