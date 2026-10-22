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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildValidationRow('At least 1 lowercase letter', hasLowerCase),
        buildValidationRow('At least 1 uppercase letter', hasUpperCase),
        buildValidationRow('At least 1 special character', hasSpecialCharacters),
        buildValidationRow('At least 1 number', hasNumbers),
        buildValidationRow('At least 8 characters long', hasMinLength),
      ],
    );
  }
}

Widget buildValidationRow(String text, bool hasValidated) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(
          hasValidated ? Icons.check_circle : Icons.circle,
          size: 10,
          color: hasValidated ? const Color(0xFF12B76A) : AppColors.lightGray,
        ),
        horizantalSpace(6),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.font12DarkBlue500W.copyWith(
              decoration: hasValidated ? TextDecoration.lineThrough : null,
              decorationColor: const Color(0xFF12B76A),
              decorationThickness: 2,
              color: hasValidated ? AppColors.gray : AppColors.darkBlue,
            ),
          ),
        ),
      ],
    ),
  );
}
