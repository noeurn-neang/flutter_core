import 'dart:async';

import 'package:get/get_connect/http/src/request/request.dart';

import '../../configs/variables.dart';
import '../../constants/common.dart';
import '../../services/index.dart';

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
