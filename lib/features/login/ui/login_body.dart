import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/login/ui/widgets/dont_have_an_account.dart';
import 'package:docdoc/features/login/ui/widgets/email_and_password.dart';
import 'package:docdoc/features/login/ui/widgets/forgot_password_button.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveCenter(
        maxWidth: AppBreakpoints.form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: _formKey,
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
                  "We're excited to have you back. Sign in to manage your "
                  'appointments and find the right doctor.',
                  style: AppTextStyles.font14Gray400W.copyWith(
                    wordSpacing: 1.2,
                    height: 1.6,
                  ),
                ),
                verticalSpace(36),
                EmailAndPassword(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  enabled: !widget.isLoading,
                ),
                verticalSpace(12),
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ForgotPasswordButton(),
                ),
                verticalSpace(24),
                CustomButton(
                  buttonText: 'Login',
                  isLoading: widget.isLoading,
                  onTap: _validateThenDoLogin,
                ),
                verticalSpace(28),
                const TermsAndConditions(),
                verticalSpace(18),
                DontHaveAnAccount(enabled: !widget.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateThenDoLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<LoginCubit>().emitLoginState(
          LoginRequestBody(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }
}
