import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        children: [
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
                return 'Please enter a valid email';
              }
            },
          ),
          verticalSpace(16),
          CustomTextFormField(
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
            },
          ),

          verticalSpace(36),

          CustomButton(buttonText: 'Create Account'),
          verticalSpace(24),
        ],
      ),
    );
  }
}
