import 'package:dartz/dartz.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/model/login_response.dart';

abstract class LoginRepo {
  Future <Either<ErrorHandler ,LoginResponse >> login(LoginRequestBody loginRequestBody);
}