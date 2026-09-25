import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpListener extends StatelessWidget {
  const SignUpListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          current is Loading || current is Failure || current is Success,
      listener: (context, state) {
        state.whenOrNull(
          loading: () => showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),
          failure: (errMessage) {
            return setupFailureState(context, errMessage);
          },
          success: (user) {
            context.pop();
            context.pushReplacementNamed(Routes.home);
          },
        );
      },
      child: SizedBox.shrink(),
    );
  }

  Future<dynamic> setupFailureState(BuildContext context, String errMessage) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red),
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
