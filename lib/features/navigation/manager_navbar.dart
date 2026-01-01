import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class ManagerNavBar extends StatelessWidget {
  final int currentIndex;

  const ManagerNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/manager_home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/manager_offers');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/manager_createrequest');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/manager_reports');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/manager_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.grey800 : AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, 0, Icons.home, "Ana Sayfa"),
            _navItem(context, 1, Icons.shopping_cart, "Teklifler"),
            _navItem(context, 2, Icons.request_page, "Talep Oluştur"),
            _navItem(context, 3, Icons.bar_chart, "Raporlar"),
            _navItem(context, 4, Icons.person, "Profil"),
          ],
        ),
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
    final Color activeColor = AppColors.accent;
    final Color inactiveColor = AppColors.grey400;

    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
