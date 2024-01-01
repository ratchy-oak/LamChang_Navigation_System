import 'package:application/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppText {
  static const header = TextStyle(
    color: AppColors.white,
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );
  static const subtitle = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const body = TextStyle(
    color: AppColors.grey,
    fontWeight: FontWeight.w400,
  );
  static const button = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const error = TextStyle(
    color: AppColors.red,
    fontSize: 12,
  );
}
