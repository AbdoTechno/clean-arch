import 'dart:developer';

import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('========== REQUEST ==========');
    log('Method: ${options.method}');
    log('URL: ${options.uri}');
    log('Headers: ${options.headers}');
    log('Data: ${options.data}');
    log('Query Parameters: ${options.queryParameters}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('========== RESPONSE ==========');
    log('Status Code: ${response.statusCode}');
    log('Data: ${response.data}');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('========== ERROR ==========');
    log('Status Code: ${err.response?.statusCode}');
    log('Message: ${err.message}');
    log('Response: ${err.response?.data}');

    handler.next(err);
  }
}
