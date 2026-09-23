import 'package:docdoc/core/helpers/app_regex.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:docdoc/features/sign_up/ui/widgets/sign_up_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpTextFormFields extends StatefulWidget {
  const SignUpTextFormFields({super.key});

  @override
  State<SignUpTextFormFields> createState() => _SignUpTextFormFieldsState();
}

class _SignUpTextFormFieldsState extends State<SignUpTextFormFields> {
  bool isObsecured = false;
  bool hasLowerCase = false;
  bool hasUpperCase = false;
  bool hasSpecialCharacters = false;
  bool hasNumbers = false;
  bool hasMinLength = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    passwordController = context.read<SignUpCubit>().passwordController;

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
      key: context.read<SignUpCubit>().formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: context.read<SignUpCubit>().nameController,
            hintText: 'Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name';
              }

              return null;
            },
          ),

          verticalSpace(16),

          CustomTextFormField(
            controller: context.read<SignUpCubit>().emailController,
            hintText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }

              return null;
            },
          ),

          verticalSpace(16),

          CustomTextFormField(
            controller: context.read<SignUpCubit>().phoneController,
            hintText: 'Phone',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid phone';
              }

              return null;
            },
          ),

          verticalSpace(16),

          CustomTextFormField(
            controller: context.read<SignUpCubit>().genderController,
            hintText: 'Gender',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid gender';
              }

              return null;
            },
          ),

          verticalSpace(16),

          CustomTextFormField(
            controller: context.read<SignUpCubit>().passwordController,
            isObsecured: isObsecured,
            visibilityAction: () {
              setState(() {
                isObsecured = !isObsecured;
              });
            },
            suffixIcon: isObsecured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            hintText: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }

              if (!hasLowerCase) {
                return 'Password must contain a lowercase letter';
              }

              if (!hasUpperCase) {
                return 'Password must contain an uppercase letter';
              }

              if (!hasSpecialCharacters) {
                return 'Password must contain a special character';
              }

              if (!hasNumbers) {
                return 'Password must contain a number';
              }

              if (!hasMinLength) {
                return 'Password must be at least 8 characters';
              }

              return null;
            },
          ),

          verticalSpace(16),

          CustomTextFormField(
            controller: context
                .read<SignUpCubit>()
                .passwordConfirmationController,
            isObsecured: isObsecured,
            visibilityAction: () {
              setState(() {
                isObsecured = !isObsecured;
              });
            },
            suffixIcon: isObsecured
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            hintText: 'Confirm Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }

              return null;
            },
          ),

          verticalSpace(36),

          CustomButton(
            buttonText: 'Create Account',
            onTap: () {
              validateThenDoSignUp(context);
            },
          ),

          verticalSpace(24),

          SignUpListener(),
        ],
      ),
    );
  }

  void validateThenDoSignUp(BuildContext context) {
    final isValid = context
        .read<SignUpCubit>()
        .formKey
        .currentState!
        .validate();

    print('Form isValid: $isValid');

    if (isValid) {
      context.read<SignUpCubit>().emitSignUpState();
    }
  }
}
