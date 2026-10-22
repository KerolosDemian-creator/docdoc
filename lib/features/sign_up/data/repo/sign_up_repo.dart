import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';

abstract class SignUpRepo {
  Future<Either<ErrorHandler, LocalUser>> signUp(
    SignUpRequestBody signUpRequestBody,
  );
}
