import 'package:clean_arch/core/databases/api/api_consumer.dart';
import 'package:clean_arch/core/databases/api/dio_config.dart';
import 'package:clean_arch/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio = DioConfig().getDio();

  @override
  Future<dynamic> get(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<dynamic> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await dio.patch(
        url,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(
    Object url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        url.toString(),
        data: data,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }
}
