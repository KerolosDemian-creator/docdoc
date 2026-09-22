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
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            hintText: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid password';
              }
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
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            hintText: 'Confirm Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid email';
              }
              if (value !=
                  context.read<SignUpCubit>().passwordController.text) {}
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
    if (context.read<SignUpCubit>().formKey.currentState!.validate()) {
      context.read<SignUpCubit>().emitSignUpState();
    }
  }
}
