import 'package:dartz/dartz.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_response.dart';

abstract class SignUpRepo {
  Future<Either<ErrorHandler, SignUpResponse>> signUp(
    SignUpRequestBody signUpRequestBody,
  );
}
