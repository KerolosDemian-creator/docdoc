import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/model/login_response.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  LoginCubit(this._loginRepo) : super(LoginState.initial());
  void emitLoginState(LoginRequestBody loginRequestBody) async {
    emit(const LoginState.loading());
    final response = await _loginRepo.login(loginRequestBody);
    response.fold(
      (error) => emit(
        LoginState.failure(errMessage: error.apiErrorModel.message.toString()),
      ),
      (user) => emit(LoginState.success(user)),
    );
  }
}
