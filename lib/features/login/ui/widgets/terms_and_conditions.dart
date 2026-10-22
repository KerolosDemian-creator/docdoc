import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTermsDialog(context),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'By continuing, you agree to our ',
              style: AppTextStyles.font12LightGray400W,
            ),
            TextSpan(
              text: 'Terms & Conditions ',
              style: AppTextStyles.font12DarkBlue500W,
            ),
            TextSpan(
              text: 'and ',
              style: AppTextStyles.font12LightGray400W,
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: AppTextStyles.font12DarkBlue500W,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Terms & Privacy'),
        content: const SingleChildScrollView(
          child: Text(
            'DocDoc is an offline demo application. Accounts and appointments '
            'are stored only on this device and are not sent to a server.\n\n'
            'By creating an account you agree to use the app for demonstration '
            'purposes. Do not enter real medical or sensitive personal data.\n\n'
            'You can remove all locally stored data by uninstalling the app.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
