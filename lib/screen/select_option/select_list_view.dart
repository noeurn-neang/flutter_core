import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/selects/select_option.dart';
import '../../constants/dimens.dart';
import 'items/country_item.dart';
import 'items/select_option_item.dart';
import 'select_list_controller.dart';

class SelectListView extends GetView<SelectListController> {
  final dynamic selected = json.decode(Get.parameters['selected']!);
  final SelectOptionResult? resultType =
      SelectOptionResult.values.byName(Get.parameters['resultType']!);

  SelectListView({super.key});

  Widget searchTextBar() {
    return Container(
      // Add padding around the search bar
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.marginLarge, vertical: Dimens.margin),
      // Use a Material design search bar
      child: TextField(
        controller: controller.searchTextController,
        onChanged: (value) {
          controller.onSearchTextChange(value);
        },
        decoration: InputDecoration(
          hintText: 'Search...',
          // Add a clear button to the search bar
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchTextController.text = '';
              controller.onSearchTextChange('');
            },
          ),
          // Add a search icon or button to the search bar
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  String getTitle() {
    switch (controller.dataType) {
      case SelectOptionDataType.country:
        return 'Countries';
      default:
        return 'Select Options';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTitle())),
      body: Column(
        children: [
          searchTextBar(),
          Expanded(
              child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (controller.dataType == SelectOptionDataType.country) {
                      return CountryItem(
                          onItemClick: () {
                            controller.handleItemClick(controller.items[index]);
                          },
                          selected: selected,
                          item: controller.items[index],
                          valueKey: controller.valueKey,
                          labelKey: controller.labelKey);
                    } else {
                      return SelectOptionItem(
                          onItemClick: () {
                            controller.handleItemClick(controller.items[index]);
                          },
                          item: controller.items[index],
                          valueKey: controller.valueKey,
                          labelKey: controller.labelKey);
                    }
                  })))
        ],
      ),
    );
  }
}
