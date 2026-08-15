import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/dimens.dart';

class SelectionItem {
  const SelectionItem({
    required this.id,
    required this.name,
    this.icon,
  });

  final String id;
  final String name;
  final Widget? icon;
}

class DialogUtils {
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom + Dimens.marginExtraLarge,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(ctx).height * 0.55,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
                  trailing: IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ),
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showSelection(
    BuildContext context,
    List<SelectionItem> items, {
    String title = 'Select',
    String selectedId = '',
    ValueChanged<String>? onItemSelected,
  }) {
    return showBottomSheet(
      context,
      title: title.tr,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          final selected = item.id == selectedId;
          return ListTile(
            leading: item.icon,
            title: Text(item.name),
            trailing: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? Theme.of(ctx).colorScheme.primary : null,
            ),
            onTap: () {
              onItemSelected?.call(item.id);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }
}
