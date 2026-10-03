import 'package:clean_arch/core/databases/api/dio_interceptor.dart';
import 'package:clean_arch/core/databases/api/end_points.dart';
import 'package:dio/dio.dart';

class DioConfig {
  // singleton
  static final DioConfig _instance = DioConfig._internal();
  factory DioConfig() => _instance;
  DioConfig._internal();

  Dio getDio() {
    final dio = Dio();
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    dio.interceptors.add(DioInterceptor());
    return dio;
  }
}
