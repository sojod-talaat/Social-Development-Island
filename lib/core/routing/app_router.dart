import 'package:flutter/material.dart';
import 'package:island_social_development/views/admin_app/add_doura_screen.dart';

import 'package:island_social_development/views/admin_app/contest_screen.dart';
import 'package:island_social_development/views/admin_app/type_contet_screen.dart';
import 'package:island_social_development/views/admin_app/home_screen.dart';
import 'package:island_social_development/views/auth/screens/sign_in_screen.dart';
import 'package:island_social_development/views/auth/screens/sign_up_screen.dart';
import 'package:island_social_development/views/splash_screen.dart';
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
      // case addQuestion:
      //   return MaterialPageRoute(builder: (_) =>  AddQuestionPage());
    }

    return null;
  }
}
