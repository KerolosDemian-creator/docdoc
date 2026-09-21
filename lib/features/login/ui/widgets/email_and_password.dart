import 'package:docdoc/core/helpers/app_regex.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/login/ui/widgets/password_validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObsecure = false;
  late TextEditingController passwordController;

  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialCharacters = false;
  bool hasNumbers = false;
  bool hasMinLength = false;

  @override
  void initState() {
    passwordController = context.read<LoginCubit>().passwordEditingController;
    setupControllerListener();
    super.initState();
  }

  void setupControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowerCase = AppRegex.hasLowerCase(passwordController.text);
        hasUpperCase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters = AppRegex.hasSpecialCharacters(
          passwordController.text,
        );
        hasNumbers = AppRegex.hasNumbers(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,

      child: Column(
        children: [
          CustomTextFormField(
            controller: context.read<LoginCubit>().emailEditingController,
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }
            },
          ),
          verticalSpace(16),
          CustomTextFormField(
            controller: passwordController,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
            },
          ),
          verticalSpace(8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PasswordValidations(
              hasLowerCase: hasLowerCase,
              hasUpperCase: hasUpperCase,
              hasSpecialCharacters: hasSpecialCharacters,
              hasNumbers: hasNumbers,
              hasMinLength: hasMinLength,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
