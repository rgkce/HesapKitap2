import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  // Açık Tema
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: TextTheme(
      displayLarge: AppStyles.heading1.copyWith(color: AppColors.textDark),
      displayMedium: AppStyles.heading2.copyWith(color: AppColors.textDark),
      displaySmall: AppStyles.heading3.copyWith(color: AppColors.textDark),
      bodyLarge: AppStyles.bodyText.copyWith(color: AppColors.textDark),
      bodyMedium: AppStyles.bodyTextBold.copyWith(color: AppColors.textDark),
      labelLarge: AppStyles.buttonText,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Colors.white,
          onPrimary: AppColors.textLight,
          onSecondary: AppColors.textDark,
          onSurface: AppColors.textDark,
        )
        .copyWith(secondary: AppColors.accent)
        .copyWith(surface: AppColors.backgroundLight),
  );

  // Koyu Tema
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: TextTheme(
      displayLarge: AppStyles.heading1.copyWith(color: AppColors.textLight),
      displayMedium: AppStyles.heading2.copyWith(color: AppColors.textLight),
      displaySmall: AppStyles.heading3.copyWith(color: AppColors.textLight),
      bodyLarge: AppStyles.bodyText.copyWith(color: AppColors.textLight),
      bodyMedium: AppStyles.bodyTextBold.copyWith(color: AppColors.textLight),
      labelLarge: AppStyles.buttonText,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.grey800,
          onPrimary: AppColors.textLight,
          onSecondary: AppColors.textLight,
          onSurface: AppColors.textLight,
        )
        .copyWith(secondary: AppColors.accent)
        .copyWith(surface: AppColors.backgroundDark),
  );
}
