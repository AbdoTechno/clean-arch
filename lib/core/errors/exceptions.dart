import 'package:clean_arch/core/errors/error_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});
}

class CacheException implements Exception {
  final String errorMessage;

  CacheException({required this.errorMessage,});
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

// ==================== Status Code Exceptions ====================

class BadRequestException extends ServerException {
  BadRequestException({required super.errorModel});
}

class UnauthorizedException extends ServerException {
  UnauthorizedException({required super.errorModel});
}

class ForbiddenException extends ServerException {
  ForbiddenException({required super.errorModel});
}

class NotFoundException extends ServerException {
  NotFoundException({required super.errorModel});
}

class ConflictException extends ServerException {
  ConflictException({required super.errorModel});
}

class UnprocessableEntityException extends ServerException {
  UnprocessableEntityException({required super.errorModel});
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException({required super.errorModel});
}

class BadGatewayException extends ServerException {
  BadGatewayException({required super.errorModel});
}

class ServiceUnavailableException extends ServerException {
  ServiceUnavailableException({required super.errorModel});
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
      return _handleBadResponse(exception.response?.statusCode, errorModel);

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

// ==================== Status Code Handler ====================

ServerException _handleBadResponse(int? statusCode, ErrorModel errorModel) {
  switch (statusCode) {
    case 400:
      return BadRequestException(errorModel: errorModel);

    case 401:
      return UnauthorizedException(errorModel: errorModel);

    case 403:
      return ForbiddenException(errorModel: errorModel);

    case 404:
      return NotFoundException(errorModel: errorModel);

    case 409:
      return ConflictException(errorModel: errorModel);

    case 422:
      return UnprocessableEntityException(errorModel: errorModel);

    case 500:
      return InternalServerErrorException(errorModel: errorModel);

    case 502:
      return BadGatewayException(errorModel: errorModel);

    case 503:
      return ServiceUnavailableException(errorModel: errorModel);

    default:
      return BadResponseException(errorModel: errorModel);
  }
}

// ==================== Error Model Parser ====================

ErrorModel _getErrorModel(DioException exception) {
  final data = exception.response?.data;

  if (data is Map<String, dynamic>) {
    return ErrorModel.fromJson(data);
  }

  return ErrorModel(
    status: exception.response?.statusCode,
    errorMessage: exception.message ?? 'Something went wrong',
  );
}
