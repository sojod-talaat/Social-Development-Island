import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/quiz_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/admin_app/contests/add_question_screen.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FamilyDate extends StatefulWidget {
  const FamilyDate({super.key});

  @override
  State<FamilyDate> createState() => _FamilyDateState();
}

class _FamilyDateState extends State<FamilyDate> {
  String formattedDate = "";
  DateTime? data;
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quizProvider, child) => Scaffold(
        appBar: AppBar(title: Text('أضف مسابقة شهرية جديدة')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                CustomTextField(
                  validator: (value) =>
                      quizProvider.validateRamdanName(value ?? ''),

                  controller: quizProvider.ramdanName,
                  //prefix: const Icon(Icons.person_outline),
                  hint: 'اسم المسابقة ',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  validator: (value) =>
                      quizProvider.validateRamdan(value ?? ''),
                  controller: quizProvider.ramdandate,
                  keyboardType: TextInputType.name,
                  hint: 'تاريخ بدء المسابقة ',
                  textInputAction: TextInputAction.done,
                  suffix: IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          data = pickedDate;
                          formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          quizProvider.ramdandate.text = formattedDate;

                          setState(() {
                            quizProvider.ramdandate.text = formattedDate;
                          });
                        } else {}
                      },
                      icon: const Icon(Icons.date_range_outlined)),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () async {
                      quizProvider.AddQuiz(data!);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddQuestionsPage(
                              id: quizProvider.ramdanName.text,
                              count: 30,
                              type: 1)));
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
                    child: const Text('اضافة'),
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
