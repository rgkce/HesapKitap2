import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class HKGradientButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final List<Color> colors;
  final double borderRadius;
  final double height;
  final bool expand; // true ise genişlik full olur

  const HKGradientButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.colors,
    this.borderRadius = 16,
    this.height = 52,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonColors =
        isDark
            ? colors
                .map((c) => c.withOpacity(0.8))
                .toList() // dark için biraz koyu
            : colors; // light için normal

    final textColor = isDark ? AppColors.grey100 : AppColors.textLight;

    final child = Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: buttonColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.backgroundDark.withOpacity(0.5)
                    : AppColors.grey600.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: textColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: AppStyles.buttonText.copyWith(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (expand) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}
