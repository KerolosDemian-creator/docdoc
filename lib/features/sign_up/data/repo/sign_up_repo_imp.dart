import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';

class SignUpRepoImp implements SignUpRepo {
  SignUpRepoImp(this._authStorage);

  final AuthStorage _authStorage;

  @override
  Future<Either<ErrorHandler, LocalUser>> signUp(
    SignUpRequestBody signUpRequestBody,
  ) async {
    try {
      final user = await _authStorage.register(
        name: signUpRequestBody.name,
        email: signUpRequestBody.email,
        phone: signUpRequestBody.phone,
        gender: signUpRequestBody.gender,
        password: signUpRequestBody.password,
      );
      return right(user);
    } on AuthException catch (error) {
      return left(ErrorHandler.local(error.message));
    } on Object {
      return left(
        ErrorHandler.local(
          'Unable to create your account. Please try again.',
        ),
      );
    }
  }
}
