import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void showMessage(String body, {bool isError = false, VoidCallback? onClose}) {
  final context = Get.context;
  if (context == null) return;

  final scheme = Theme.of(context).colorScheme;
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.hideCurrentSnackBar();
  messenger
      .showSnackBar(
        SnackBar(
          content: Text(
            body,
            style: TextStyle(
              color: isError ? scheme.onError : scheme.onInverseSurface,
            ),
          ),
          backgroundColor: isError ? scheme.error : scheme.inverseSurface,
        ),
      )
      .closed
      .then((_) => onClose?.call());
}

void showLoading({String? message}) {
  EasyLoading.show(
    status: message,
    maskType: EasyLoadingMaskType.custom,
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
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(desc),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelLabel ?? 'Cancel'.tr),
          ),
          FilledButton(
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
