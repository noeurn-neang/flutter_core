import 'package:flutter/material.dart';

class CoreMetrics {
  CoreMetrics._(this.size, this.viewPadding);

  final Size size;
  final EdgeInsets viewPadding;

  factory CoreMetrics.of(BuildContext context) {
    final media = MediaQuery.of(context);
    return CoreMetrics._(media.size, media.viewPadding);
  }

  double get windowHeight => size.height;
  double get statusBarHeight => viewPadding.top;
  double get screenHeight => windowHeight - statusBarHeight;
  double get screenWidth => size.width;
  bool get isTablet => size.shortestSide > 700;
}
