import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/login/ui/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
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
        return Scaffold(body: LoginBody(isLoading: state is Loading));
      },
    );
  }
}
