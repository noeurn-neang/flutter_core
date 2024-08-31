import 'package:flutter/material.dart';

import '../getx.dart';

TextStyle titleSmallStyle = Theme.of(Get.context!).textTheme.titleSmall!;
TextStyle titleMediumStyle = Theme.of(Get.context!).textTheme.titleMedium!;
TextStyle titleLargeStyle = Theme.of(Get.context!).textTheme.titleLarge!;

TextStyle formLabelStyle = Theme.of(Get.context!)
    .textTheme
    .titleSmall!
    .copyWith(fontWeight: FontWeight.bold);
