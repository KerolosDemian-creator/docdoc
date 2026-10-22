import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';

class DontHaveAnAccount extends StatelessWidget {
  const DontHaveAnAccount({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            "Don't have an account yet?",
            style: AppTextStyles.font11Gray400W.copyWith(
              color: AppColors.darkBlue,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: enabled ? () => context.pushNamed(Routes.signUp) : null,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('Sign Up', style: AppTextStyles.font11MainBlue600W),
        ),
      ],
    );
  }
}
