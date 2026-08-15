import 'package:flutter/material.dart';

import '../../utils/dialog_utils.dart';

class SelectOptionController extends TextEditingController {
  Map<String, dynamic>? selected;

  void setSelected(Map<String, dynamic> value, String labelKey) {
    selected = value;
    text = '${value[labelKey] ?? ''}';
  }
}

class SelectOption extends StatelessWidget {
  const SelectOption({
    super.key,
    this.title,
    this.enabled = true,
    this.controller,
    this.border,
    this.icon,
    this.labelKey = 'label',
    this.valueKey = 'code',
    this.validator,
    this.items = const [],
    this.itemIcon,
  });

  final String? title;
  final bool enabled;
  final SelectOptionController? controller;
  final InputBorder? border;
  final Widget? icon;
  final String labelKey;
  final String valueKey;
  final FormFieldValidator<String>? validator;
  final List<Map<String, dynamic>> items;
  final Widget Function(Map<String, dynamic> item)? itemIcon;

  Future<void> _openPicker(BuildContext context) async {
    if (items.isEmpty) return;
    final selectedId = '${controller?.selected?[valueKey] ?? ''}';
    await DialogUtils.showSelection(
      context,
      items
          .map(
            (item) => SelectionItem(
              id: '${item[valueKey]}',
              name: '${item[labelKey]}',
              icon: itemIcon?.call(item),
            ),
          )
          .toList(),
      title: title ?? 'Select',
      selectedId: selectedId,
      onItemSelected: (id) {
        final match = items.firstWhere((item) => '${item[valueKey]}' == id);
        controller?.setSelected(match, labelKey);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: enabled ? () => _openPicker(context) : null,
      validator: validator,
      enabled: enabled,
      readOnly: true,
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: border,
        labelText: title,
        icon: icon,
        suffixIcon: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
