// To parse this JSON data, do
//
//     final responseError = responseErrorFromJson(jsonString);

import 'dart:convert';

ResponseError responseErrorFromJson(String str) =>
    ResponseError.fromJson(json.decode(str));

String responseErrorToJson(ResponseError data) => json.encode(data.toJson());

class ResponseError {
  dynamic status;
  String? type;
  String? message;
  dynamic error;

  ResponseError({
    this.status,
    this.type,
    this.message,
    this.error,
  });

  factory ResponseError.fromJson(Map<String, dynamic> json) => ResponseError(
        status: json["status"],
        type: json["type"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "type": type,
        "message": message,
        "error": error,
      };
}
