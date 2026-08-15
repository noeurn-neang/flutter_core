import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void showMessage(String body, {bool isError = false, VoidCallback? onClose}) {
  final context = Get.context;
  final scheme = context != null ? Theme.of(context).colorScheme : null;
  Get.snackbar(
    isError ? 'Error'.tr : 'Success'.tr,
    body,
    backgroundColor: isError
        ? (scheme?.error ?? Colors.red)
        : (scheme?.primary ?? Colors.green),
    colorText: isError
        ? (scheme?.onError ?? Colors.white)
        : (scheme?.onPrimary ?? Colors.white),
    snackbarStatus: (status) {
      if (status == SnackbarStatus.CLOSED) {
        onClose?.call();
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

Future<bool?> showCoreConfirm(
  BuildContext context, {
  required String title,
  required String desc,
  String? confirmLabel,
  String? cancelLabel,
}) {
  return showAdaptiveDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel ?? 'Cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel ?? 'Confirm'.tr),
          ),
        ],
      );
    },
  );
}

void showConfirm(
  String title,
  String desc, {
  Icon? icon,
  VoidCallback? onConfirm,
  VoidCallback? onReject,
}) {
  final context = Get.context;
  if (context == null) return;
  showCoreConfirm(context, title: title, desc: desc).then((confirmed) {
    if (confirmed == true) {
      onConfirm?.call();
    } else {
      onReject?.call();
    }
  });
}
