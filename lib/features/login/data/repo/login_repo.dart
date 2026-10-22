import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';

abstract class LoginRepo {
  Future<Either<ErrorHandler, LocalUser>> login(
    LoginRequestBody loginRequestBody,
  );
}
