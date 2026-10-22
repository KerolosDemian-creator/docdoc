import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_model.g.dart';

const defaultErrorMessage = 'Something went wrong. Please try again.';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;
  final dynamic data;
  final bool? status;

  ApiErrorModel({required this.message, this.code, this.data, this.status});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  /// A safe message that can always be displayed to the user.
  String get displayMessage {
    if (data is Map) {
      final dataMap = Map<String, dynamic>.from(data as Map);
      if (dataMap.isNotEmpty) {
        final firstValue = dataMap.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }
      }
    }
    final value = message?.trim();
    return (value == null || value.isEmpty) ? defaultErrorMessage : value;
  }

  Map<String, String> get fieldErrors {
    if (data is Map) {
      final dataMap = Map<String, dynamic>.from(data as Map);
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
