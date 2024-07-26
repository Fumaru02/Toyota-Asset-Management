import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_colors.dart';
import '../utils/enums.dart';
import '../utils/size_config.dart';

class Snack {
  Snack._();

  static dynamic show(
    SnackbarType snackbarType,
    String title,
    String message, {
    Color? backgroundColor,
    Color? colorText,
    Duration? duration,
  }) {
    if (Get.isSnackbarOpen) {
      return Get.back();
    } else {
      final Color? background;
      if (snackbarType == SnackbarType.error) {
        background = AppColors.redAlert;
      } else {
        if (snackbarType == SnackbarType.success) {
          background = AppColors.greenDark;
        } else {
          if (snackbarType == SnackbarType.info) {
            background = AppColors.redAlert;
          } else {
            background = backgroundColor;
          }
        }
      }
      return Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        colorText: colorText ?? Colors.white,
        backgroundColor: background,
        snackStyle: SnackStyle.FLOATING,
        duration: duration ?? const Duration(milliseconds: 4000),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.horizontal(1),
          horizontal: SizeConfig.horizontal(4),
        ),
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.horizontal(1),
          horizontal: SizeConfig.horizontal(2),
        ),
      );
    }
  }
}
