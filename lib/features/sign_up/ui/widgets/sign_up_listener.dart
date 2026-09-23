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
            barrierDismissible: false,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          ),

          failure: (errMessage) {
            context.pop();

            final fieldErrors = context.read<SignUpCubit>().fieldErrors;

            print('fieldErrors: $fieldErrors');

            if (fieldErrors.isNotEmpty) {
              String? firstError;

              // Check errors in the same order as the form
              if (fieldErrors.containsKey('name')) {
                firstError = fieldErrors['name'];
              } else if (fieldErrors.containsKey('email')) {
                firstError = fieldErrors['email'];
              } else if (fieldErrors.containsKey('phone')) {
                firstError = fieldErrors['phone'];
              } else if (fieldErrors.containsKey('gender')) {
                firstError = fieldErrors['gender'];
              } else if (fieldErrors.containsKey('password')) {
                firstError = fieldErrors['password'];
              } else if (fieldErrors.containsKey('password_confirmation')) {
                firstError = fieldErrors['password_confirmation'];
              }

              if (firstError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(firstError),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            } else {
              setupFailureState(context, errMessage);
            }
          },

          success: (user) {
            context.pop();
            context.pushReplacementNamed(Routes.home);
          },
        );
      },
      child: Container(),
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
            onPressed: () {
              context.pop();
            },
            child: Text('Got it', style: AppTextStyles.font12DarkBlue500W),
          ),
        ],
      ),
    );
  }
}
