import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:docdoc/features/sign_up/ui/widgets/sign_up_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) =>
          current is Success || current is Failure,
      listener: (context, state) {
        state.whenOrNull(
          success: (user) {
            context.pushNamedAndRemoveUntil(
              Routes.home,
              predicate: (_) => false,
            );
          },
          failure: (errMessage) {
            showAppSnackBar(context, errMessage, isError: true);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(body: SignUpBody(isLoading: state is Loading));
      },
    );
  }
}
