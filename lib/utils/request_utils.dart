import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'message_utils.dart';

void handleRequestError(Response response) {
  try {
    final body = response.body;
    String messageBody = '';
    if (kDebugMode) {
      print('Error Body: $body');
    }

    if (body != null && body['success'] == false) {
      messageBody = body['message'];
      showMessage(messageBody, isError: true);
    } else {
      showMessage('Please check your internet!'.tr, isError: true);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error Body: $e');
    }

    showMessage(response.body, isError: true);
  }
}
