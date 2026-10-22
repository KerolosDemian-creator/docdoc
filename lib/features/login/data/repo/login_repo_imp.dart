import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';

class LoginRepoImp implements LoginRepo {
  LoginRepoImp(this._authStorage);

  final AuthStorage _authStorage;

  @override
  Future<Either<ErrorHandler, LocalUser>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final user = await _authStorage.login(
        email: loginRequestBody.email,
        password: loginRequestBody.password,
      );
      return right(user);
    } on AuthException catch (error) {
      return left(ErrorHandler.local(error.message));
    } on Object {
      return left(
        ErrorHandler.local('Unable to sign in right now. Please try again.'),
      );
    }
  }
}
