import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/app_regex.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset password'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the email you signed up with and choose a new password.',
              ),
              verticalSpace(16),
              CustomTextFormField(
                controller: _emailController,
                hintText: 'Email',
                enabled: !_isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Please enter your email';
                  if (!AppRegex.isEmailValid(email)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              verticalSpace(12),
              CustomTextFormField(
                controller: _passwordController,
                hintText: 'New password',
                enabled: !_isLoading,
                isObsecured: _obscure,
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
                visibilityAction: () {
                  setState(() => _obscure = !_obscure);
                },
                validator: (value) {
                  if (value == null || !AppRegex.isPasswordValid(value)) {
                    return 'Use 8+ characters with upper, lower, number & symbol';
                  }
                  return null;
                },
              ),
              verticalSpace(12),
              CustomTextFormField(
                controller: _confirmController,
                hintText: 'Confirm new password',
                enabled: !_isLoading,
                isObsecured: _obscure,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              if (_errorMessage != null) ...[
                verticalSpace(12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _resetPassword,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Reset'),
        ),
      ],
    );
  }

  Future<void> _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await getIt<AuthStorage>().resetPassword(
        email: _emailController.text,
        newPassword: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to reset your password. Please try again.';
      });
    }
  }
}
