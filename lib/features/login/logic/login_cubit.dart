import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepo) : super(LoginState.initial());

  final LoginRepo _loginRepo;

  Future<void> emitLoginState(LoginRequestBody loginRequestBody) async {
    if (state is Loading) return;

    emit(const LoginState.loading());
    final response = await _loginRepo.login(loginRequestBody);

    if (isClosed) return;

    response.fold(
      (error) => emit(
        LoginState.failure(errMessage: error.apiErrorModel.displayMessage),
      ),
      (user) => emit(LoginState.success(user)),
    );
  }
}
