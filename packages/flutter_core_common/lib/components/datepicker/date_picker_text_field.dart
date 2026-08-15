import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/date_formats.dart';

class DatePickerTextField extends StatelessWidget {
  const DatePickerTextField({
    super.key,
    this.title,
    this.enabled = true,
    this.validator,
    this.controller,
    this.border,
    this.icon,
    this.decoration,
    this.align,
    this.firstDate,
    this.lastDate,
  });

  final String? title;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final InputBorder? border;
  final Widget? icon;
  final InputDecoration? decoration;
  final TextAlign? align;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Future<void> showDatePickerDialog(BuildContext context) async {
    final parsed = DateFormats.tryParse(controller?.text);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: parsed ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 5)),
      cancelText: 'Cancel'.tr,
      confirmText: 'Ok'.tr,
      fieldLabelText: 'Select Date'.tr,
    );

    if (pickedDate != null && controller != null) {
      controller!.text = DateFormats.format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: enabled ? () => showDatePickerDialog(context) : null,
      validator: validator,
      enabled: enabled,
      readOnly: true,
      controller: controller,
      textInputAction: TextInputAction.next,
      textAlign: align ?? TextAlign.start,
      decoration: decoration ??
          InputDecoration(
            border: border,
            labelText: title,
            icon: icon,
            suffixIcon: const Icon(Icons.calendar_today_outlined),
          ),
    );
  }
}
