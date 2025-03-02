import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/models/competition_model.dart';
import 'package:island_social_development/views/admin_app/contests/add_question_screen.dart';
import 'package:island_social_development/views/admin_app/contests/all_competition_question.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:island_social_development/views/auth/widgets/snak_bar.dart';
import 'package:provider/provider.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CometitionScreenState();
}

class _CometitionScreenState extends State<CompetitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('المسابقات'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'إنشاء مسابقة'),
                Tab(text: 'المسابقات الجاهزة'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // صفحة إنشاء المسابقة
              CreateCompetitionTab(),
              // صفحة المسابقات الجاهزة
              ReadyCompetitionsTab(competitionList: quizProvider.competitions2),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateCompetitionTab extends StatelessWidget {
  const CreateCompetitionTab({super.key});

  @override
  Widget build(BuildContext context) {
    CompetitionModel competitionModel;
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Form(
            key: quizProvider.competitioKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text('قم باضافة مسابقة جديدة'),
                const SizedBox(height: 12),
                CustomTextField(
                  validator: (value) =>
                      quizProvider.validateCompetitionName(value ?? ''),
                  controller: quizProvider.contestName,
                  hint: 'اسم المسابقة',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  validator: (value) =>
                      quizProvider.validateCompetitonLeth(value ?? ''),
                  controller: quizProvider.conestlenght,
                  hint: 'عدد الأسئلة',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  validator: (value) =>
                      quizProvider.validateCompetitonLeth(value ?? ''),
                  controller: quizProvider.timerController,
                  hint: 'مدة المسابقة',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  suffix: IconButton(
                    onPressed: () {
                      //quizProvider.setTimerDuration(context);
                    },
                    icon: const Icon(Icons.timer),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      if (quizProvider.competitioKey.currentState!.validate()) {
                        competitionModel = quizProvider.addComptition();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionsPage(
                              count: competitionModel.questionCount,
                              id: competitionModel.id,
                              type: 2,
                            ),
                          ),
                        );
                        quizProvider.contestName.clear();
                        quizProvider.conestlenght.clear();
                        quizProvider.timerController.clear();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.darkBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: const Text('انتقل لاضافة الأسئلة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReadyCompetitionsTab extends StatelessWidget {
  final List<CompetitionModel>? competitionList;

  ReadyCompetitionsTab({super.key, required this.competitionList});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          value.competitions2.length != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('اسم المسابقة '),
                    Text('زمن المسابقة '),
                    Text('بداء المسابقة '),
                  ],
                )
              : Text("لا يتوفر مسابقات لعرضها "),
          Expanded(
            child: ListView.builder(
              itemCount: competitionList!.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        // await value.fetchCompetionQuestions(
                        //     value.getCategory(value.category),
                        //     value.getType(value.type),
                        //     competitionList![index].id);
                        print(value.fetchCompetionQuestions(
                            value.getCategory(value.category),
                            value.getType(value.type),
                            competitionList![index].id));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AllQuestionsScreen(
                                  Questions: value.questions3,
                                )));
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // لون الخلفية
                          border: Border.all(
                            color: Colors.grey, // لون الحدود
                            width: 2, // سمك الحدود
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // لجعل الزوايا دائرية
                        ),
                        child: Text(competitionList![index].title),
                      ),
                    ),
                    Container(
                      width: 50,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // لون الحدود
                          width: 2, // سمك الحدود
                        ),
                        borderRadius:
                            BorderRadius.circular(10), // لجعل الزوايا دائرية
                      ),
                      child: Text(competitionList![index].timer.toString()),
                    ),
                    InkWell(
                      onTap: () {
                        String type = value.getType(value.type);
                        if (value.category == 1) {
                          switch (type) {
                            case "general":
                              Provider.of<QuizProvider>(context).youthGenral =
                                  competitionList![index];
                            case "scientific":
                              Provider.of<QuizProvider>(context)
                                  .youthscientific = competitionList![index];
                            case "islamic":
                              Provider.of<QuizProvider>(context).youthislamic =
                                  competitionList![index];
                          }
                          SnakBarWidget.show(
                              context, "تم ارسال المسابقة بنجاح");
                        } else {
                          switch (type) {
                            case "general":
                              Provider.of<QuizProvider>(context).kidsGenral =
                                  competitionList![index];
                            case "scientific":
                              Provider.of<QuizProvider>(context).kidscientific =
                                  competitionList![index];
                            case "islamic":
                              Provider.of<QuizProvider>(context).kidsislamic =
                                  competitionList![index];
                          }
                          SnakBarWidget.show(
                              context, "تم ارسال المسابقة بنجاح");
                        }
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          // لون الخلفية
                          border: Border.all(
                            color: Colors.grey, // لون الحدود
                            width: 2, // سمك الحدود
                          ),
                          borderRadius:
                              BorderRadius.circular(10), // لجعل الزوايا دائرية
                        ),
                        child: const Center(
                            child: Text(
                          'إرسال',
                        )),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
