import 'package:flutter/material.dart';

extension ViewExtension on BuildContext {
  bool get isWideScreen => MediaQuery.of(this).size.width > 640;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}
