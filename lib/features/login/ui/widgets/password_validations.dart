import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class PasswordValidations extends StatelessWidget {
  const PasswordValidations({
    super.key,
    required this.hasLowerCase,
    required this.hasUpperCase,
    required this.hasSpecialCharacters,
    required this.hasNumbers,
    required this.hasMinLength,
  });
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacters;
  final bool hasNumbers;
  final bool hasMinLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidationRow('At least 1 Lowercase letter', hasLowerCase),
        buildValidationRow('At least 1 Uppercase letter', hasUpperCase),
        buildValidationRow(
          'At least 1 Special character',
          hasSpecialCharacters,
        ),
        buildValidationRow('At least 1 Number', hasNumbers),
        buildValidationRow('At least 8 Characters long', hasMinLength),
      ],
    );
  }
}

Widget buildValidationRow(String text, bool hasValidated) {
  return Row(
    children: [
      CircleAvatar(radius: 2.5, backgroundColor: AppColors.gray),
      verticalSpace(6),
      Text(
        text,
        style: AppTextStyles.font12DarkBlue500W.copyWith(
          decoration: hasValidated ? TextDecoration.lineThrough : null,
          decorationColor: Colors.green,
          decorationThickness: 2,
          color: hasValidated ? AppColors.gray : AppColors.darkBlue,
        ),
      ),
    ],
  );
}
