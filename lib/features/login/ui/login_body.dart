import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/login/ui/widgets/already_have_an_account_yet.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  bool isObsecure = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Welcome Back',
                  style: AppTextStyles.font24MainBlue700W,
                ),
              ),
              verticalSpace(8),
              Text(
                'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in.',
                style: AppTextStyles.font14Gray400W.copyWith(
                  wordSpacing: 3,
                  height: 1.6,
                ),
              ),
              verticalSpace(36),
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(hintText: 'Email'),
                    verticalSpace(16),
                    CustomTextFormField(
                      isObsecured: isObsecure,
                      hintText: 'Password',
                      suffixIcon: isObsecure == false
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      visibilityAction: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },
                    ),
                    verticalSpace(20),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.font12MainBlue400W,
                      ),
                    ),
                    verticalSpace(35),
                    CustomButton(buttonText: 'Login'),
                    verticalSpace(46),
                    TermsAndConditions(),
                    verticalSpace(24),
                    AlreadyHaveAnAccountYet(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
