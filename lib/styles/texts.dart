import 'package:flutter/material.dart';

import '../getx.dart';

TextStyle titleSmallStyle =
    Theme.of(Get.context!).textTheme.titleSmall!.copyWith(fontSize: 12);
TextStyle titleMediumStyle =
    Theme.of(Get.context!).textTheme.titleMedium!.copyWith(fontSize: 14);
TextStyle titleLargeStyle =
    Theme.of(Get.context!).textTheme.titleLarge!.copyWith(fontSize: 16);

TextStyle formLabelStyle = Theme.of(Get.context!)
    .textTheme
    .titleSmall!
    .copyWith(fontWeight: FontWeight.bold);
