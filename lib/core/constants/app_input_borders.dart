import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppInputBorders {
  AppInputBorders._();

  static OutlineInputBorder base() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.divider),
    );
  }

  static OutlineInputBorder focused() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    );
  }

  static OutlineInputBorder error() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    );
  }

  static OutlineInputBorder focusedError() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    );
  }
}
