import 'package:docdoc/core/helpers/app_regex.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/login/ui/widgets/password_validations.dart';
import 'package:docdoc/features/login/ui/widgets/terms_and_conditions.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:docdoc/features/sign_up/ui/widgets/already_have_an_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasSpecialCharacters = false;
  bool _hasNumbers = false;
  bool _hasMinLength = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
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
    return SafeArea(
      child: ResponsiveCenter(
        maxWidth: AppBreakpoints.form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: widget.isLoading ? null : () => context.pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                ),
                verticalSpace(8),
                Text(
                  'Create Account',
                  style: AppTextStyles.font24MainBlue700W,
                ),
                verticalSpace(8),
                Text(
                  'Sign up now and start exploring all that our app has to offer. '
                  'We\'re excited to welcome you to our community!',
                  style: AppTextStyles.font14Gray400W.copyWith(height: 1.5),
                ),
                verticalSpace(28),
                CustomTextFormField(
                  controller: _nameController,
                  hintText: 'Full name',
                  enabled: !widget.isLoading,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (value) {
                    if ((value?.trim().length ?? 0) < 2) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  enabled: !widget.isLoading,
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
                  controller: _phoneController,
                  hintText: 'Phone (01XXXXXXXXX)',
                  enabled: !widget.isLoading,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final phone = value?.trim() ?? '';
                    if (phone.isEmpty) return 'Please enter your phone number';
                    if (!AppRegex.isPhoneNumberValid(phone)) {
                      return 'Enter a valid Egyptian phone number';
                    }
                    return null;
                  },
                ),
                verticalSpace(16),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: _dropdownDecoration(),
                  hint: Text(
                    'Gender',
                    style: AppTextStyles.font14LightGray500W,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: widget.isLoading
                      ? null
                      : (value) => setState(() => _gender = value),
                  validator: (value) =>
                      value == null ? 'Please select your gender' : null,
                ),
                verticalSpace(16),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: 'Password',
                  enabled: !widget.isLoading,
                  isObsecured: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  suffixIcon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  visibilityAction: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!AppRegex.isPasswordValid(value)) {
                      return 'Your password does not meet the requirements';
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
                verticalSpace(16),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  enabled: !widget.isLoading,
                  isObsecured: _obscureConfirmation,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  suffixIcon: Icon(
                    _obscureConfirmation
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  visibilityAction: () {
                    setState(
                      () => _obscureConfirmation = !_obscureConfirmation,
                    );
                  },
                  onFieldSubmitted: (_) => _validateThenSignUp(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                verticalSpace(24),
                CustomButton(
                  buttonText: 'Create Account',
                  isLoading: widget.isLoading,
                  onTap: _validateThenSignUp,
                ),
                verticalSpace(22),
                const TermsAndConditions(),
                verticalSpace(12),
                AlreadyHaveAnAccount(enabled: !widget.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    final radius = BorderRadius.circular(16.r);
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
      fillColor: AppColors.lightWhite,
      filled: true,
      errorMaxLines: 2,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lighterGray, width: 1.3),
        borderRadius: radius,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightestGray, width: 1.3),
        borderRadius: radius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.mainBlue, width: 1.3),
        borderRadius: radius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.3),
        borderRadius: radius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.3),
        borderRadius: radius,
      ),
    );
  }

  void _validateThenSignUp() {
    if (widget.isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<SignUpCubit>().emitSignUpState(
          SignUpRequestBody(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            gender: _gender!,
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          ),
        );
  }
}
