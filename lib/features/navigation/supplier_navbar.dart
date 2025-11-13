import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class SupplierNavBar extends StatelessWidget {
  final int currentIndex;

  const SupplierNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/supplier_home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/supplier_requests');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/supplier_payments');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/supplier_stock');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/supplier_reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [AppColors.grey600, AppColors.primary.withOpacity(0.9)]
                  : [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.accent.withOpacity(0.8),
                  ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, 0, Icons.home, "Ana Sayfa"),
          _navItem(context, 1, Icons.assignment, "Talepler"),
          _navItem(context, 2, Icons.payment, "Ödemeler"),
          _navItem(context, 3, Icons.shopping_bag, "Stok"),
          _navItem(context, 4, Icons.bar_chart, "Raporlar"),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.grey100 : AppColors.grey400,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(
              color: isActive ? AppColors.grey100 : AppColors.grey400,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
