import 'package:flutter/material.dart';

import '../../constants/countries.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/translate_utils.dart';

enum SelectOptionDataType { country, general }

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
    this.type = SelectOptionDataType.general,
    this.labelKey = 'label',
    this.valueKey = 'code',
    this.validator,
    this.items = const [],
  });

  final String? title;
  final bool enabled;
  final SelectOptionController? controller;
  final InputBorder? border;
  final Widget? icon;
  final SelectOptionDataType type;
  final String labelKey;
  final String valueKey;
  final FormFieldValidator<String>? validator;
  final List<Map<String, dynamic>> items;

  Future<void> _openPicker(BuildContext context) async {
    final source = type == SelectOptionDataType.country ? countries : items;
    final selectedId = '${controller?.selected?[valueKey] ?? ''}';
    await DialogUtils.showSelection(
      context,
      source
          .map(
            (item) => SelectionItem(
              id: '${item[valueKey]}',
              name: '${item[labelKey]}',
              icon: type == SelectOptionDataType.country
                  ? getFlagCountryCode('${item[valueKey]}')
                  : null,
            ),
          )
          .toList(),
      title: title ?? 'Select',
      selectedId: selectedId,
      onItemSelected: (id) {
        final match = source.firstWhere((item) => '${item[valueKey]}' == id);
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
        border: border ?? const OutlineInputBorder(),
        labelText: title,
        icon: icon,
        suffixIcon: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
