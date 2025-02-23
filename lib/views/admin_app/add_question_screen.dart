import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/theme/app_style.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddQuestionsPage extends StatefulWidget {
  final String id;
  final int count;
  int type;

  AddQuestionsPage(
      {super.key, required this.id, required this.count, required this.type});

  @override
  State<AddQuestionsPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) => Scaffold(
          appBar: AppBar(
            title: const Text("اضف مسابقة جديدة"),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: quizProvider.questionKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    widget.type == 1
                        ? Text(
                            "الأسئلة المتبقية: ${quizProvider.maxQuestions - quizProvider.addedFamQuestions}",
                            style: Styles.textStyle16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          )
                        : Text(
                            "الأسئلة المتبقية: ${quizProvider.addedQuestion - widget.count}",
                            style: Styles.textStyle16.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBlue,
                            ),
                          ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      focusNode: quizProvider.focusNode,
                      controller: quizProvider.questionController,
                      hint: 'ادخل السؤال',
                      prefix: Icon(
                        Icons.question_mark,
                        color:
                            quizProvider.isFocused ? Colors.teal : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OptionsWidget(
                      textEditingController: quizProvider.quizoptionA,
                      backgroundcolor: Colors.amber,
                      texteieldtitle: 'الخيار الأول',
                      optiontitle: 'أ',
                    ),
                    const SizedBox(height: 10),
                    OptionsWidget(
                      textEditingController: quizProvider.quizoptionB,
                      backgroundcolor: Colors.green,
                      texteieldtitle: 'الخيار الثاني',
                      optiontitle: 'ب',
                    ),
                    const SizedBox(height: 10),
                    OptionsWidget(
                      textEditingController: quizProvider.quizoptionC,
                      backgroundcolor: Colors.purple,
                      texteieldtitle: 'الخيار الثالث',
                      optiontitle: 'ج',
                    ),
                    const SizedBox(height: 10),
                    OptionsWidget(
                      textEditingController: quizProvider.quizoptionD,
                      backgroundcolor: Colors.pink,
                      texteieldtitle: 'الخيار الرابع',
                      optiontitle: 'د',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'اختر الإجابة الصحيحة',
                          style: Styles.textStyle16.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(
                              height: 1.5,
                              color: AppColors.darkBlue,
                            ),
                            value: quizProvider.dropdownvalue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                quizProvider.dropdownvalue2 = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                  value: 'A', child: Center(child: Text('A'))),
                              DropdownMenuItem(
                                  value: 'B', child: Center(child: Text('B'))),
                              DropdownMenuItem(
                                  value: 'C', child: Center(child: Text('C'))),
                              DropdownMenuItem(
                                  value: 'D', child: Center(child: Text('D'))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.type == 1) {
                            if (quizProvider.questions2.length < widget.count) {
                              quizProvider.addNewQuestiontoFam1(
                                quizProvider.questionController.text,
                                [
                                  quizProvider.quizoptionA.text,
                                  quizProvider.quizoptionB.text,
                                  quizProvider.quizoptionC.text,
                                  quizProvider.quizoptionD.text
                                ],
                                quizProvider.dropdownvalue,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("تم الوصول إلى الحد الأقصى للأسئلة"),
                                ),
                              );
                            }
                          } else {
                            quizProvider.addNewQuestion(
                                competitionId: widget.id,
                                maxQuestions: widget.count,
                                context: context);
                          }
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
                        child: const Text('اضافة'),
                      ),
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

// ignore: must_be_immutable
class OptionsWidget extends StatelessWidget {
  String optiontitle;
  String texteieldtitle;
  Color backgroundcolor;
  TextEditingController textEditingController;
  OptionsWidget(
      {Key? key,
      required this.optiontitle,
      required this.texteieldtitle,
      required this.backgroundcolor,
      required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, value, child) => Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundcolor,
            radius: 25,
            child: Text(
              optiontitle,
              style: Styles.textStyle18
                  .copyWith(fontSize: 30, fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: CustomTextField(
              controller: textEditingController,
              hint: texteieldtitle,
            ),
          )
        ],
      ),
    );
  }
}
