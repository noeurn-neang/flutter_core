import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '../../utils/string_utils.dart';

class DatePickerTextField extends StatelessWidget {
  final String? title;
  final bool? enabled;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final InputBorder? border;
  final Widget? icon;

  const DatePickerTextField(
      {super.key,
      this.title,
      this.enabled,
      this.validator,
      this.controller,
      this.border,
      this.icon});

  Future<void> showDatePickerDialog(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: StringUtils.isNotNull(controller!.text)
            ? StringUtils.toDate(controller!.text)
            : DateTime.now(),
        firstDate:
            DateTime.now().subtract(const Duration(days: 365 * 10)), // 10 years
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // 1 year
        cancelText: 'Cancel'.tr,
        confirmText: 'Ok'.tr,
        fieldLabelText: 'Select Date'.tr);

    if (pickedDate != null && controller != null) {
      controller!.text = "${pickedDate.toLocal()}".split(' ')[0];
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
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: title,
        icon: icon,
      ),
    );
  }
}
