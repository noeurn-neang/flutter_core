import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../utils/request_utils.dart';

FutureOr<dynamic> responseInterceptor(
    Request request, Response response) async {
  if (kDebugMode) {
    print('Http Response Code: ${response.statusCode}');
    print('Http Response Body: ${response.body}');
  }

  // Save updated token to storage
  handleRequestSuccess(response);

  if (response.statusCode == 401) {
    // Force to login page
  }

  return response;
}
