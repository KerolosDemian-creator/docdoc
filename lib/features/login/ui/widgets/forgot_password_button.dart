import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/login/ui/widgets/forgot_password_dialog.dart';
import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final didReset = await showDialog<bool>(
          context: context,
          builder: (_) => const ForgotPasswordDialog(),
        );

        if (didReset == true && context.mounted) {
          showAppSnackBar(
            context,
            'Your password has been updated. You can sign in now.',
          );
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Forgot Password?',
        style: AppTextStyles.font12MainBlue400W,
      ),
    );
  }
}
