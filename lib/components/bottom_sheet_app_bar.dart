import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens.dart';

class BottomSheetAppBar extends StatelessWidget {
  final String title;
  final Widget? rightElement;
  final VoidCallback? onClose;

  const BottomSheetAppBar(
    this.title, {
    super.key,
    this.rightElement,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.margin,
        horizontal: Dimens.marginLarge,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (rightElement != null) ...[rightElement!],
          IconButton(
              onPressed: () {
                Get.back();
                if (onClose != null) {
                  onClose!();
                }
              },
              icon: const Icon(Icons.close))
        ],
      ),
    );
  }
}
