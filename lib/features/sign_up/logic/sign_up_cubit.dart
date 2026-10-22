import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUpRepo) : super(SignUpState.initial());

  final SignUpRepo _signUpRepo;

  Future<void> emitSignUpState(SignUpRequestBody signUpRequestBody) async {
    if (state is Loading) return;

    emit(const SignUpState.loading());
    final response = await _signUpRepo.signUp(signUpRequestBody);

    if (isClosed) return;

    response.fold(
      (error) => emit(
        SignUpState.failure(errMessage: error.apiErrorModel.displayMessage),
      ),
      (user) => emit(SignUpState.success(user)),
    );
  }
}
