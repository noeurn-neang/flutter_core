import 'package:flutter/material.dart';

class SelectOptionItem extends StatelessWidget {
  final VoidCallback onItemClick;
  final Map<String, dynamic> item;
  final Map<String, dynamic>? selected;
  final String valueKey;
  final String labelKey;

  const SelectOptionItem(
      {super.key,
      required this.onItemClick,
      required this.item,
      required this.valueKey,
      required this.labelKey,
      this.selected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onItemClick();
      },
      title: Text(item[labelKey]),
      trailing: (selected != null && item[valueKey] == selected![valueKey])
          ? const Icon(Icons.check)
          : null,
    );
  }
}
