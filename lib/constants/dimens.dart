import 'package:flutter/material.dart';

class Dimens {
  Dimens._();

  static const double borderRadius = 8;

  static const double marginSmall = 5;
  static const double margin = 10;
  static const double marginLarge = 16;
  static const double marginExtraLarge = 25;

  static const double iconSmall = 15;
  static const double icon = 20;
  static const double iconLarge = 25;
  static const double iconXLarge = 35;

  static const double textSmall = 12;
  static const double text = 14;
  static const double textLarge = 18;

  static const vmxl = SizedBox(
    height: marginExtraLarge,
  );
  static const vml = SizedBox(
    height: marginLarge,
  );
  static const hml = SizedBox(
    width: marginLarge,
  );
  static const vmm = SizedBox(
    height: margin,
  );
  static const hmm = SizedBox(
    width: margin,
  );
  static const vms = SizedBox(
    height: marginSmall,
  );
  static const hms = SizedBox(
    width: marginSmall,
  );
}
