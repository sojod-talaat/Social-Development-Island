import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/core/utils/hive_box.dart';
import 'package:island_social_development/models/user_model.dart';
import 'package:island_social_development/views/user_app/screens/Family/fam_question.dart';
import 'package:island_social_development/views/user_app/screens/quizes.dart';
import 'package:island_social_development/views/user_app/screens/type_contest_screen.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart'; // أيقونات حديثة وجميلة

class CompetitionGridScreen extends StatefulWidget {
  const CompetitionGridScreen({Key? key}) : super(key: key);

  @override
  State<CompetitionGridScreen> createState() => _CompetitionGridScreenState();
}

class _CompetitionGridScreenState extends State<CompetitionGridScreen> {
  int age = 0;
  @override
  void initState() async {
    super.initState();
    SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "title": "المسابقات العامة",
        "icon": LucideIcons.globe,
        "gradient": [Colors.blue, Colors.blueAccent],
      },
      {
        "title": "المسابقات العلمية",
        "icon": LucideIcons.flaskConical,
        "gradient": [Colors.green, Colors.lightGreenAccent],
      },
      {
        "title": "المسابقات الشرعية",
        "icon": LucideIcons.bookOpen,
        "gradient": [Colors.orange, Colors.deepOrangeAccent],
      },
      {
        "title": "مسابقات الأسرة",
        "icon": LucideIcons.users,
        "gradient": [Colors.red, Colors.pinkAccent],
      },
    ];

    return Consumer<QuizProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("أنواع المسابقات"),
          backgroundColor: AppColors.darkBlue,
          elevation: 5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عدد الأعمدة
              crossAxisSpacing: 12.0, // المسافة الأفقية بين العناصر
              mainAxisSpacing: 12.0, // المسافة الرأسية بين العناصر
              childAspectRatio: 1.0, // نسبة العرض إلى الارتفاع
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  switch (index) {
                    case 0:
                      await value.getCompetitions(context, "general");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTypeContestScreen(
                            competition: (value.currentUser!.age == 12)
                                ? value.kidsGenral!
                                : value.youthGenral!,
                            type: "general",
                          ),
                        ),
                      );
                      break;
                    case 1:
                      // ignore: use_build_context_synchronously
                      await value.getCompetitions(context, "scientific");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTypeContestScreen(
                            competition: (value.currentUser!.age == 12)
                                ? value.kidscientific!
                                : value.kidscientific!,
                            type: "scientific",
                          ),
                        ),
                      );
                      break;
                    case 2:
                      // ignore: use_build_context_synchronously
                      await value.getCompetitions(context, "islamic");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTypeContestScreen(
                            competition: (value.currentUser!.age == 12)
                                ? value.kidsislamic!
                                : value.youthislamic!,
                            type: "islamic",
                          ),
                        ),
                      );
                      break;
                    case 3:
                      await value.getAllQuizes();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              QuizesScreen(quiz: value.quizes)));
                      break;
                  }
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.darkBlue, AppColors.secondaryGreen],
                      //categories[index]['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        categories[index]['icon'],
                        size: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        categories[index]['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
