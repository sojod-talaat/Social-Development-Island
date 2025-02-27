import 'package:flutter/material.dart';
import 'package:island_social_development/views/admin_app/contests/contest_screen.dart';
import 'package:island_social_development/views/admin_app/contests/type_contet_screen.dart';
import 'package:island_social_development/views/admin_app/dourat/add_doura_screen.dart';
import 'package:island_social_development/views/admin_app/home/home_screen.dart';
import 'package:island_social_development/views/auth/screens/comforem_email.dart';
import 'package:island_social_development/views/auth/screens/reset_password.dart';
import 'package:island_social_development/views/auth/screens/sign_in_screen.dart';
import 'package:island_social_development/views/auth/screens/sign_up_screen.dart';
import 'package:island_social_development/views/splash_screen.dart';
import 'package:island_social_development/views/user_app/screens/Family/fam_contest.dart';
import 'package:island_social_development/views/user_app/screens/Family/family_home.dart';
import 'package:island_social_development/views/user_app/screens/contest_screen2.dart';
import 'package:island_social_development/views/user_app/screens/dourat.dart';
import 'package:island_social_development/views/user_app/screens/pray_time_screen.dart';
import 'package:island_social_development/views/user_app/screens/user_home_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String signin = '/Signin';
  static const String signup = '/signup';
  static const String userhome = '/userhome';
  static const String adminhome = '/adminhome';
  static const String praytime = '/praytime';
  static const String addDoura = '/addDoura';
  static const String dourat = '/dourat';
  static const String typecontest = '/typecontest';
  static const String userCompetition = '/userCom';
  static const String adminCometition = '/adminCom';
  static const String addQuestion = '/addquestion';
  static const String forgetPassword = '/forgetPassword';
  static const String confirmationPage = '/confirma';
  static const String famQuizes = '/famQuizes';
  static const String familyhome = '/famhome';
  static const String competion = '/competiton';

  Route? generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case userhome:
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
      case adminhome:
        return MaterialPageRoute(builder: (_) => AdminHomeScreen());
      case addDoura:
        return MaterialPageRoute(builder: (_) => const AddDouraScreen());
      case dourat:
        return MaterialPageRoute(builder: (_) => const DouratScreen());
      case praytime:
        return MaterialPageRoute(builder: (_) => PrayerTimesPage());
      case typecontest:
        return MaterialPageRoute(builder: (_) => const TypeContestScreen());
      case userCompetition:
        return MaterialPageRoute(builder: (_) => const CompetitionGridScreen());
      case adminCometition:
        return MaterialPageRoute(builder: (_) => const CompetitionScreen());
      case confirmationPage:
        return MaterialPageRoute(builder: (_) => ResetConfirmationPage());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case famQuizes:
        return MaterialPageRoute(
            builder: (_) => const FamCompetitionGridScreen());
      case familyhome:
        return MaterialPageRoute(builder: (_) => FamHomeScreen());
      case competion:
        return MaterialPageRoute(builder: (_) => CompetitionScreen());
    }

    return null;
  }
}
