import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/string_utils.dart';

class TimePickerTextField extends StatelessWidget {
  final String? title;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final InputBorder? border;
  final Widget? icon;
  final InputDecoration? decoration;

  const TimePickerTextField(
      {super.key,
      this.title,
      this.enabled,
      this.validator,
      this.controller,
      this.border,
      this.icon,
      this.decoration});

  Future<void> showDatePickerDialog(BuildContext context) async {
    final TimeOfDay? pickedDate = await showTimePicker(
        context: context,
        initialTime: StringUtils.isNotNull(controller!.text)
            ? StringUtils.toTime(controller!.text)
            : TimeOfDay.now(),
        cancelText: 'Cancel'.tr,
        confirmText: 'Ok'.tr);

    if (pickedDate != null && controller != null) {
      controller!.text = pickedDate.format(Get.context!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        showDatePickerDialog(context);
      },
      validator: validator,
      enabled: enabled,
      readOnly: true,
      controller: controller,
      textInputAction: TextInputAction.next,
      textAlignVertical: TextAlignVertical.center,
      decoration: decoration ??
          InputDecoration(
            border: border ?? const UnderlineInputBorder(),
            labelText: title,
            icon: icon,
          ),
    );
  }
}
