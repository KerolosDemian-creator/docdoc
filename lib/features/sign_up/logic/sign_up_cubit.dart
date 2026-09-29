import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_response.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.dart';
part 'sign_up_cubit.freezed.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepo _signUpRepo;
  Map<String, String> fieldErrors = {};

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  SignUpCubit(this._signUpRepo) : super(SignUpState.initial());

  void emitSignUpState() async {
    emit(SignUpState.loading());
    final response = await _signUpRepo.signUp(
      SignUpRequestBody(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        gender: genderController.text,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      ),
    );
    response.fold((errorHandler) {
      fieldErrors = errorHandler.apiErrorModel.fieldErrors;
      emit(
        SignUpState.failure(
          errMessage:
              errorHandler.apiErrorModel.message ?? 'Something went wrong',
        ),
      );
    }, (user) => emit(SignUpState.success(user)));
  }
}
