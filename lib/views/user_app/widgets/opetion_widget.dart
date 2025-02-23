// import 'package:flutter/material.dart';
// import 'package:island_social_development/core/theme/app_style.dart';
// import 'package:island_social_development/core/utils/app_color.dart';

// class QuizOptionWidget extends StatelessWidget {
//   String option;

//   QuizOptionWidget({super.key, required this.option});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppColors.darkBlue, width: 1.5),
//       ),
//       child: Text(
//         option,
//         style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class QuizOptionWidget extends StatelessWidget {
  final String option;
  final bool isSelected;

  const QuizOptionWidget({
    required this.option,
    this.isSelected = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        option,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
