import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/string_utils.dart';

class TimePickerTextField extends StatelessWidget {
  const TimePickerTextField({
    super.key,
    this.title,
    this.enabled = true,
    this.validator,
    this.controller,
    this.border,
    this.icon,
    this.decoration,
  });

  final String? title;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final InputBorder? border;
  final Widget? icon;
  final InputDecoration? decoration;

  Future<void> showTimePickerDialog(BuildContext context) async {
    TimeOfDay initial = TimeOfDay.now();
    if (StringUtils.isNotBlank(controller?.text)) {
      try {
        initial = StringUtils.toTime(controller!.text);
      } catch (_) {}
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      cancelText: 'Cancel'.tr,
      confirmText: 'Ok'.tr,
    );

    if (picked != null && controller != null && context.mounted) {
      controller!.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: enabled ? () => showTimePickerDialog(context) : null,
      validator: validator,
      enabled: enabled,
      readOnly: true,
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: decoration ??
          InputDecoration(
            border: border,
            labelText: title,
            icon: icon,
            suffixIcon: const Icon(Icons.schedule),
          ),
    );
  }
}
