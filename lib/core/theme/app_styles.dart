import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800, // Extra bold for primary headers
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // Body
  static const TextStyle bodyText = TextStyle(
    fontSize: 15,
    height: 1.5, // Better readability
  );

  static const TextStyle bodyTextBold = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  // Buttons & Labels
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textGrey,
    fontWeight: FontWeight.w500,
  );
}
