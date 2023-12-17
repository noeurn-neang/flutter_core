import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (rightElement != null) ...[rightElement!],
          InkWell(
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Icon(Icons.close),
            ),
            onTap: () {
              Get.back();
              if (onClose != null) {
                onClose!();
              }
            },
          ),
        ],
      ),
    );
  }
}
