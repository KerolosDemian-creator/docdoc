import 'package:dio/dio.dart';

import 'api_error_model.dart';

/// Translates exceptions into a user-presentable [ApiErrorModel].
///
/// Network failures, malformed error bodies and local validation errors all go
/// through here so the UI only has to deal with one error type.
class ErrorHandler implements Exception {
  ErrorHandler(this.apiErrorModel);

  final ApiErrorModel apiErrorModel;

  factory ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      return ErrorHandler(_fromDioException(error));
    }
    return ErrorHandler(
      ApiErrorModel(message: ErrorHandler.localMessage, status: false),
    );
  }

  factory ErrorHandler.local(String message) {
    return ErrorHandler(
      ApiErrorModel(message: message, code: 400, status: false),
    );
  }

  static const localMessage = defaultErrorMessage;
}

ApiErrorModel _fromDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return ApiErrorModel(
        message: 'The request timed out. Please try again.',
        code: -1,
        status: false,
      );
    case DioExceptionType.connectionError:
      return ApiErrorModel(
        message: 'No internet connection. Please check your network.',
        code: -2,
        status: false,
      );
    case DioExceptionType.cancel:
      return ApiErrorModel(
        message: 'The request was cancelled.',
        code: -3,
        status: false,
      );
    case DioExceptionType.badCertificate:
      return ApiErrorModel(
        message: 'The server certificate could not be verified.',
        code: -4,
        status: false,
      );
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return _fromResponse(error.response);
  }
}

ApiErrorModel _fromResponse(Response<dynamic>? response) {
  final data = response?.data;
  if (data is Map<String, dynamic>) {
    try {
      return ApiErrorModel.fromJson(data);
    } on Object {
      // Fall through to a status based message.
    }
  }

  final statusCode = response?.statusCode;
  return ApiErrorModel(
    message: _messageForStatus(statusCode),
    code: statusCode,
    status: false,
  );
}

String _messageForStatus(int? statusCode) {
  switch (statusCode) {
    case 400:
      return 'The request was invalid. Please check your details.';
    case 401:
      return 'Your session has expired. Please sign in again.';
    case 403:
      return 'You do not have permission to perform this action.';
    case 404:
      return 'The requested resource was not found.';
    case 422:
      return 'Some of the details you entered are invalid.';
    case 500:
    case 502:
    case 503:
      return 'The server is unavailable right now. Please try again later.';
    default:
      return ErrorHandler.localMessage;
  }
}
