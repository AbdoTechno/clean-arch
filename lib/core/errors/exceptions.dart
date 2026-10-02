import 'package:clean_arch/core/errors/error_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});
}

class CacheException implements Exception {
  final String errorMessage;

  CacheException({required this.errorMessage});
}

// ==================== Dio Exceptions ====================

class BadCertificateException extends ServerException {
  BadCertificateException({required super.errorModel});
}

class ConnectTimeoutException extends ServerException {
  ConnectTimeoutException({required super.errorModel});
}

class SendTimeoutException extends ServerException {
  SendTimeoutException({required super.errorModel});
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException({required super.errorModel});
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException({required super.errorModel});
}

class BadResponseException extends ServerException {
  BadResponseException({required super.errorModel});
}

class CancelException extends ServerException {
  CancelException({required super.errorModel});
}

class UnknownException extends ServerException {
  UnknownException({required super.errorModel});
}

// ==================== Dio Exception Handler ====================

ServerException handleDioException(DioException exception) {
  final errorModel = _getErrorModel(exception);

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
      return ConnectTimeoutException(errorModel: errorModel);

    case DioExceptionType.sendTimeout:
      return SendTimeoutException(errorModel: errorModel);

    case DioExceptionType.receiveTimeout:
      return ReceiveTimeoutException(errorModel: errorModel);

    case DioExceptionType.badCertificate:
      return BadCertificateException(errorModel: errorModel);

    case DioExceptionType.badResponse:
      return BadResponseException(errorModel: errorModel);

    case DioExceptionType.cancel:
      return CancelException(errorModel: errorModel);

    case DioExceptionType.connectionError:
      return ConnectionErrorException(errorModel: errorModel);

    case DioExceptionType.unknown:
      return UnknownException(errorModel: errorModel);
    case DioExceptionType.transformTimeout:
      return UnknownException(errorModel: errorModel);
  }
}

ErrorModel _getErrorModel(DioException exception) =>
    ErrorModel.fromJson(exception.response!.data);
