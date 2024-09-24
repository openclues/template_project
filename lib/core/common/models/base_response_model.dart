import 'package:equatable/equatable.dart';

class BaseResponseModel<T> extends Equatable {
  final bool? error;
  final String? message;
  final T data;

  const BaseResponseModel({
    required this.data,
    this.error,
    this.message,
  });

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponseModel(
      data: fromJsonT(json['data']),
      error: json['error'],
      message: json['message'],
    );
  }

  @override
  List<Object?> get props => [error, message, data];
}
