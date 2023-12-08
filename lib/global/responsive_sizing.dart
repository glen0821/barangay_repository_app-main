// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ResponsiveSizing {
  double? deviceWidth;
  double? deviceHeight;
  ResponsiveSizing(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
  }

  double calc_width(designWidth) {
    double width = 399;
    return deviceWidth! * (designWidth / width);
  }

  double calc_height(designHeight) {
    double height = 914;
    return deviceHeight! * (designHeight / height);
  }
}
