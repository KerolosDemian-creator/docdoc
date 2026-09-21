import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(50),
        Text('Create Account'),
        verticalSpace(8),
        Text(
          'Sign up now and start exploring all that our app has to offer. We\'re excited to welcome you to our community!',
        ),
        verticalSpace(16),

        CustomTextFormField(
          hintText: 'Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          hintText: 'Email',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          hintText: 'Phone',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          hintText: 'Gender',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          hintText: 'Password',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          hintText: 'Confirm Password',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid email';
            }
          },
        ),
        verticalSpace(36),

        CustomButton(buttonText: 'Create Account'),
        verticalSpace(50),

        TermsAndConditions(),
        // AlreadyHaveAnAccountYet()
      ],
    );
  }
}
