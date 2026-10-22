import 'package:docdoc/core/helpers/app_regex.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/login/ui/widgets/password_validations.dart';
import 'package:flutter/material.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.enabled = true,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool enabled;

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool _obscurePassword = true;

  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasSpecialCharacters = false;
  bool _hasNumbers = false;
  bool _hasMinLength = false;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_onPasswordChanged);
    _onPasswordChanged();
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  void _onPasswordChanged() {
    final password = widget.passwordController.text;
    final hasLowerCase = AppRegex.hasLowerCase(password);
    final hasUpperCase = AppRegex.hasUpperCase(password);
    final hasSpecialCharacters = AppRegex.hasSpecialCharacters(password);
    final hasNumbers = AppRegex.hasNumbers(password);
    final hasMinLength = AppRegex.hasMinLength(password);

    if (hasLowerCase == _hasLowerCase &&
        hasUpperCase == _hasUpperCase &&
        hasSpecialCharacters == _hasSpecialCharacters &&
        hasNumbers == _hasNumbers &&
        hasMinLength == _hasMinLength) {
      return;
    }

    setState(() {
      _hasLowerCase = hasLowerCase;
      _hasUpperCase = hasUpperCase;
      _hasSpecialCharacters = hasSpecialCharacters;
      _hasNumbers = hasNumbers;
      _hasMinLength = hasMinLength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: widget.emailController,
          hintText: 'Email',
          enabled: widget.enabled,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          validator: (value) {
            final email = value?.trim() ?? '';
            if (email.isEmpty) return 'Please enter your email';
            if (!AppRegex.isEmailValid(email)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        verticalSpace(16),
        CustomTextFormField(
          controller: widget.passwordController,
          hintText: 'Password',
          enabled: widget.enabled,
          isObsecured: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          suffixIcon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          visibilityAction: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        verticalSpace(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PasswordValidations(
            hasLowerCase: _hasLowerCase,
            hasUpperCase: _hasUpperCase,
            hasSpecialCharacters: _hasSpecialCharacters,
            hasNumbers: _hasNumbers,
            hasMinLength: _hasMinLength,
          ),
        ),
      ],
    );
  }
}
