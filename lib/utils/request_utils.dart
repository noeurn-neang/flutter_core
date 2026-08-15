import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'message_utils.dart';

void handleRequestError(Response response) {
  try {
    final body = response.body;
    if (kDebugMode) {
      debugPrint('Error Body: $body');
    }

    String? messageBody;
    if (body is Map && (body['success'] == false || body['message'] != null)) {
      messageBody = body['message']?.toString();
    } else if (response.statusText != null && response.statusText!.isNotEmpty) {
      messageBody = response.statusText;
    }

    showMessage(
      messageBody ?? 'Please check your internet!'.tr,
      isError: true,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error Body: $e');
    }
    showMessage('Please check your internet!'.tr, isError: true);
  }
}
