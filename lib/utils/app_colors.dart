import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static Color hex({required String colorCode}) {
    final String containHex = colorCode.toUpperCase().replaceAll('#', '');
    String result = '';
    if (colorCode.length == 7) {
      result = 'FF$containHex';
    }

    return Color(int.parse(result, radix: 16));
  }

  // color list
  // main theme color
  static Color greenDark = AppColors.hex(colorCode: '#3bc0bd');
  static Color greenSuccess = AppColors.hex(colorCode: '#88D66C');
  static Color yellowWarning = AppColors.hex(colorCode: '#FFDE4D');
  static Color redAlert = AppColors.hex(colorCode: '#FF004D');
  static Color black = AppColors.hex(colorCode: '#000000');
  static Color white = AppColors.hex(colorCode: '#FFFFFF');
  static Color blueDark = AppColors.hex(colorCode: '#0C359E');
  static Color greyDisabled = AppColors.hex(colorCode: '#DADADA');
  static Color orangeActive = AppColors.hex(colorCode: '#D37116');
  static Color maroon = AppColors.hex(colorCode: '#891652');
  static Color maroonTransparent = AppColors.hex(colorCode: '#FFC4C4');
  static Color rippleColor =
      AppColors.hex(colorCode: '#EFEFEF').withOpacity(0.20);
}
