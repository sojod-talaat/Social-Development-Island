import 'package:flutter/material.dart';
import 'package:island_social_development/core/providers/app_provider.dart';
import 'package:island_social_development/core/utils/app_color.dart';
import 'package:island_social_development/views/auth/widgets/custom_text_form_field.dart';
import 'package:island_social_development/views/auth/widgets/snak_bar.dart';
import 'package:island_social_development/views/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AddDouraScreen extends StatefulWidget {
  const AddDouraScreen({super.key});

  @override
  State<AddDouraScreen> createState() => _AddDouraScreenState();
}

class _AddDouraScreenState extends State<AddDouraScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> douratKey = GlobalKey<FormState>();
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) => Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(title: const Text('اضافة حلقة تحفيظ جديدة ')),
        body: Form(
          key: douratKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('قم باضافة حلقة تحفيظ جديدة '),
                    const SizedBox(
                      height: 12,
                    ),
                    CustomTextField(
                      validator: (value) =>
                          appProvider.validateDouraName(value ?? ''),

                      controller: appProvider.douraName,
                      //prefix: const Icon(Icons.person_outline),
                      hint: 'اسم الحلقة ',
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      validator: (value) =>
                          appProvider.validateDouraStartDate(value ?? ''),
                      controller: appProvider.douraStartDate,
                      keyboardType: TextInputType.name,
                      hint: 'تاريخ بدء الحلقة ',
                      textInputAction: TextInputAction.done,
                      suffix: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              appProvider.startDate = formattedDate;

                              setState(() {
                                appProvider.douraStartDate.text = formattedDate;
                              });
                            } else {}
                          },
                          icon: const Icon(Icons.date_range_outlined)),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      validator: (value) =>
                          appProvider.validateDouraEndDate(value ?? ''),
                      suffix: IconButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              appProvider.endDate = formattedDate;

                              setState(() {
                                appProvider.douraEndDate.text = formattedDate;
                              });
                            } else {}
                          },
                          icon: const Icon(Icons.date_range_outlined)),
                      controller: appProvider.douraEndDate,
                      keyboardType: TextInputType.name,
                      hint: 'تاريخ انتهاء الحلقة ',
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          if (appProvider.validateForm(douratKey)) {
                            appProvider.addDouraTahfiz();
                            SnakBarWidget.show(
                                context, 'تم اضافة حلقة  التحفيظ بنجاح');
                          }
                          appProvider.disposeDouraFields();
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
