import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:docdoc/features/sign_up/ui/widgets/sign_up_text_form_fields.dart';
import 'package:flutter/material.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            Text('Create Account', style: AppTextStyles.font24MainBlue700W),
            verticalSpace(8),
            Text(
              'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
              style: AppTextStyles.font14Gray400W,
            ),
            verticalSpace(16),
            SignUpTextFormFields(),

            TermsAndConditions(),
            // AlreadyHaveAnAccountYet()
          ],
        ),
      ),
    );
  }
}
