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
  void checkUserStatus(
    BuildContext context,
  ) {
    Future.delayed(const Duration(seconds: 5), () {
      auth.authStateChanges().listen((user) {
        if (user != null) {
          loadUser(
            context,
          );
        } else {
          Navigator.pushNamed(context, AppRouter.signup);
        }
      });
    });
  }

  Future<UserModel?> loadUser(BuildContext context) async {
    final userLocal = await prefsHelper.getUserModel();
    print(userLocal?.userType);
    if (userLocal != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          if (userLocal.email == "fahadj1p@gmail.com") {
            Navigator.pushReplacementNamed(context, AppRouter.adminhome);
          } else if (userLocal.userType == "family") {
            Navigator.pushReplacementNamed(context, AppRouter.familyhome);
          } else {
            Navigator.pushReplacementNamed(context, AppRouter.userhome);
          }
        }
      });
      return userLocal;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userModel = await fetchUserFromFirestore(user.uid);
      if (userModel != null) {
        await prefsHelper.saveUserModel(userModel);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            if (userModel.email == "fahadj1p@gmail.com") {
              Navigator.pushReplacementNamed(context, AppRouter.adminhome);
            } else if (userModel.userType == "family") {
              Navigator.pushReplacementNamed(context, AppRouter.familyhome);
            } else {
              Navigator.pushReplacementNamed(context, AppRouter.userhome);
            }
          }
        });

        return userModel;
      }
    }

    return null;
  }

  Future<UserModel?> fetchUserFromFirestore(String id) async {
    try {
      // 🔥 البحث أولًا في مجموعة "families"
      DocumentSnapshot familyDoc =
          await FirebaseFirestore.instance.collection('families').doc(id).get();

      if (familyDoc.exists) {
        // ✅ تحويل بيانات العائلة إلى UserModel مع تحديد `userType`
        Map<String, dynamic> familyData =
            familyDoc.data() as Map<String, dynamic>;

        UserModel user = UserModel(
          id: id,
          name: familyData['name'] ?? '',
          email: familyData['email'] ?? '', // تأكد أن هناك حقل `email`
          age: familyData['age'] ?? 0,
          userType: "family", // ✅ تأكيد أن نوع الحساب هو "family"
        );

        await prefsHelper.saveUserModel(user);
        print("✅ User found in families: ${user.name}, Type: ${user.userType}");
        return user;
      }

      // 🔥 البحث في مجموعة "users" إذا لم يُعثر عليه في "families"
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      if (userDoc.exists) {
        UserModel user =
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

        await prefsHelper.saveUserModel(user);
        print("✅ User found in users: ${user.name}, Type: ${user.userType}");
        return user;
      }

      // ❌ إذا لم يُعثر على المستخدم في أي مجموعة
      print("❌ No user found with ID: $id");
      return null;
    } catch (e) {
      print("❌ Error fetching user: $e");
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////////signout
  dynamic signout() async {
    await prefsHelper.removeUser();
    await auth.signOut();
  }
}
