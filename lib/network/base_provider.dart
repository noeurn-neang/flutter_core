import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../configs/variables.dart';
import '../constants/common.dart';
import '../services/index.dart';

abstract class BaseProvider extends GetConnect {
  final String baseApiUrl;

  BaseProvider(this.baseApiUrl) {
    httpClient.baseUrl = baseApiUrl;
    timeout = const Duration(seconds: 30);
  }

  @override
  void onInit() {
    httpClient.addRequestModifier(requestInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
    httpClient.timeout = const Duration(seconds: 30);
  }

  FutureOr<Request> requestInterceptor(request) async {
    request.headers['X-Requested-With'] = 'XMLHttpRequest';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';

    final token = StorageService.getString(StorageItem.token.toString());
    if (token != null) {
      request.headers[Variables.authHeaderKey] = token;
    }

    return request;
  }

  FutureOr<dynamic> responseInterceptor(
      Request request, Response response) async {
    if (kDebugMode) {
      print('Http Response Code: ${response.statusCode}');
      print('Http Response Body: ${response.body}');
    }

    return response;
  }
}
