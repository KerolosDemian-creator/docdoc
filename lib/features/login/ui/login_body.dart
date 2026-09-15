import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/login/ui/widgets/already_have_an_account_yet.dart';
import 'package:docdoc/features/login/ui/widgets/email_and_password.dart';
import 'package:docdoc/features/login/ui/widgets/login_listener.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EmailAndPassword(),
                  verticalSpace(20),
                  Align( 
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.font12MainBlue400W,
                    ),
                  ),
                  verticalSpace(35),
                  CustomButton(
                    buttonText: 'Login',
                    onTap: () {
                      validateThenDoLogin(context);
                    },
                  ),
                  verticalSpace(46),
                  const TermsAndConditions(),
                  verticalSpace(24),
                  const AlreadyHaveAnAccountYet(),
                  const LoginListener(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateThenDoLogin(BuildContext context) {
    if (context.read<LoginCubit>().formKey.currentState!.validate()) {
      context.read<LoginCubit>().emitLoginState(
        LoginRequestBody(
          email: context.read<LoginCubit>().emailEditingController.text,
          password: context.read<LoginCubit>().passwordEditingController.text,
        ),
      );
    }
  }
}
