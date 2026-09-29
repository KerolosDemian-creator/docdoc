import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginListener extends StatelessWidget {
  const LoginListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is Loading || current is Success || current is Failure,
      listener: (context, state) {
        state.whenOrNull(
          loading: () => showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.mainBlue),
            ),
          ),
          success: (user) {
            context.pop();
            context.pushReplacementNamed(Routes.home);
          },
          failure: (errMessage) {
            setupFailureState(context, errMessage);
          },
        );
      },
      child: SizedBox.shrink(),
    );
  }

  void setupFailureState(BuildContext context, String errMessage) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.error, color: Colors.red),
        content: Text(errMessage, style: AppTextStyles.font12DarkBlue500W),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Got it', style: AppTextStyles.font12DarkBlue500W),
          ),
        ],
      ),
    );
  }
}
