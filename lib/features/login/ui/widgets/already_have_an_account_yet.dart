import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccountYet extends StatelessWidget {
  const AlreadyHaveAnAccountYet({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Already have an account yet?  ',
          style: AppTextStyles.font11Gray400W.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
        GestureDetector(
          onTap: () => context.pushNamed(Routes.singUp),
          child: Text('Sign Up', style: AppTextStyles.font11MainBlue600W),
        ),
      ],
    );
    // RichText(
    //   text: TextSpan(
    //     children: [
    //       TextSpan(
    //         text: 'Already have an account yet?  ',
    //         style: AppTextStyles.font11Gray400W.copyWith(
    //           color: AppColors.darkBlue,
    //         ),
    //       ),
    //       TextSpan(text: 'Sign Up', style: AppTextStyles.font11MainBlue600W),
    //     ],
    //   ),
    // );
  }
}
