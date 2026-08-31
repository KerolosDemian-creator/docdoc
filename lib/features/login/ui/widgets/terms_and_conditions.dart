import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return  RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(height: 1.8),
        children: [
          TextSpan(
            text: 'By logging, you agree to our ',
            style: AppTextStyles.font12LightGray400W,
          ),
          TextSpan(
            text: 'Terms & Condition ',
            style: AppTextStyles.font12DarkBlue500W,
          ),
          TextSpan(text: 'and ', style: AppTextStyles.font12LightGray400W),
          TextSpan(
            text: 'PrivacyPolicy ',
            style: AppTextStyles.font12DarkBlue500W,
          ),
        ],
      ),
    );
  }
}
