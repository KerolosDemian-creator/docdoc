import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;
  final dynamic data;
  final bool? status;

  ApiErrorModel({required this.message, this.code, this.data, this.status});
  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);
  Map<String, dynamic> tojson() => _$ApiErrorModelToJson(this);

  String get displayMessage {
    if (data is Map) {
      final dataMap = data as Map<String, dynamic>;
      if (dataMap.isNotEmpty) {
        final firstValue = dataMap.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }
      }
    }
    return message ?? ResponseMessage.DEFAULT;
  }

  Map<String, String> get fieldErrors {
    if (data is Map) {
      final dataMap = data as Map<String, dynamic>;
      return dataMap.map((key, value) {
        final message = (value is List && value.isNotEmpty)
            ? value.first.toString()
            : value.toString();
        return MapEntry(key, message);
      });
    }
    return {};
  }
}
