import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/theme.dart';

void showMessage(String body, {bool isError = false, VoidCallback? onClose}) {
  Get.snackbar(
    isError ? 'Error'.tr : 'Success'.tr,
    body,
    backgroundColor: isError ? dangerColor : successColor,
    colorText: Colors.white,
    snackbarStatus: (status) {
      if (status == SnackbarStatus.closed) {
        if (onClose != null) {
          onClose();
        }
      }
    },
  );
}

void showLoading({String? message}) {
  EasyLoading.show(
    status: message ?? 'Loading...'.tr,
    maskType: EasyLoadingMaskType.black,
  );
}

void hideLoading() {
  EasyLoading.dismiss();
}

void showConfirm(
  String title,
  String desc, {
  Icon? icon,
  VoidCallback? onConfirm,
  VoidCallback? onReject,
}) {
  Alert(
    context: Get.context!,
    style: AlertStyle(
      descStyle: Theme.of(Get.context!).textTheme.bodyLarge!,
      titleStyle: Theme.of(Get.context!).textTheme.titleLarge!,
    ),
    title: title,
    desc: desc,
    image: icon,
    buttons: [
      DialogButton(
        onPressed: () {
          Navigator.pop(Get.context!);
          if (onReject != null) onReject();
        },
        color: const Color.fromRGBO(0, 179, 134, 1.0),
        child: Text(
          "Cancel".tr,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.pop(Get.context!);
          if (onConfirm != null) onConfirm();
        },
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0),
          ],
        ),
        child: Text(
          "Confirm".tr,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}
