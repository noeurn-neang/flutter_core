import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/selects/select_option.dart';
import '../../constants/countries.dart';

class SelectListController extends GetxController {
  final String labelKey = Get.parameters['labelKey'] ?? 'label';
  final String valueKey = Get.parameters['valueKey'] ?? 'code';
  final SelectOptionDataType? dataType =
      SelectOptionDataType.values.byName(Get.parameters['dataType']!);

  final searchTextController = TextEditingController();
  final items = <dynamic>[].obs;
  final sourceItems = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();

    sourceItems.value = getItemsSource();
    items.addAll(sourceItems.sublist(0, 20));
  }

  void onSearchTextChange(String text) {
    if (text.isNotEmpty) {
      items.value = sourceItems
          .where((element) =>
              element[labelKey]!.toLowerCase().contains(text.toLowerCase()) ||
              element[valueKey]!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    } else {
      items.clear();
      items.addAll(countries.sublist(0, 20));
    }
  }

  void handleItemClick(Map<String, dynamic> item) {
    Get.back(result: {
      'selected': json.encode(item),
    });
  }

  List<Map<String, dynamic>> getItemsSource() {
    if (dataType == SelectOptionDataType.country) {
      return countries;
    }

    return [];
  }
}
