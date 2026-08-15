import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../config/flutter_core_config.dart';
import '../constants/common.dart';
import '../services/storage_service.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final dynamic body;

  @override
  String toString() => message;
}

abstract class BaseProvider extends GetConnect {
  BaseProvider(this.baseApiUrl) {
    httpClient.baseUrl = baseApiUrl;
    httpClient.timeout = const Duration(seconds: 30);
  }

  final String baseApiUrl;

  @override
  void onInit() {
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
    super.onInit();
  }

  FutureOr<Request> requestInterceptor(Request request) async {
    request.headers['X-Requested-With'] = 'XMLHttpRequest';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    final token = StorageService.getString(StorageItem.token);
    if (token != null) {
      final config = FlutterCoreConfig.current;
      request.headers[config.authHeaderKey] =
          config.useBearerToken ? 'Bearer $token' : token;
    }

    return request;
  }

  FutureOr<dynamic> responseInterceptor(
    Request request,
    Response response,
  ) async {
    if (kDebugMode) {
      debugPrint('Http Response Code: ${response.statusCode}');
      debugPrint('Http Response Body: ${response.body}');
    }
    return response;
  }
}
