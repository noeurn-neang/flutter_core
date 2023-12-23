import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';

class SelectOption extends StatelessWidget {
  final String? title;
  final bool? enabled;
  final SelectOptionController? controller;
  final InputBorder? border;
  final Widget? icon;
  final SelectOptionDataType type;
  final SelectOptionResult? resultType;
  final String labelKey;
  final String valueKey;

  const SelectOption(
      {super.key,
      this.title,
      this.enabled = true,
      this.controller,
      this.border,
      this.icon,
      required this.type,
      this.resultType = SelectOptionResult.value,
      this.labelKey = 'label',
      this.valueKey = 'code'});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        var result = await Get.toNamed(Routes.SELECT_LIST, parameters: {
          'dataType': type.name,
          'selected': json.encode(controller!.selected),
          'resultType': resultType!.name
        });
        if (result != null && controller != null) {
          controller!.setSelected(json.decode(result['selected']), labelKey);
        }
      },
      enabled: enabled,
      readOnly: true,
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: border ?? const UnderlineInputBorder(),
        labelText: title,
        icon: icon,
        suffixIcon: const Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}

class SelectOptionController extends TextEditingController {
  Map<String, dynamic>? selected;

  setSelected(Map<String, dynamic> selected, String labelKey) {
    this.selected = selected;
    text = selected[labelKey];
  }
}

enum SelectOptionDataType {
  country,
}

enum SelectOptionResult {
  value,
  label,
}
