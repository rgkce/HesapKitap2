import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';

class ProcurementNavBar extends StatelessWidget {
  final int currentIndex;

  const ProcurementNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/procurement_home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/procurement_requests');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/procurement_add_quote');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/procurement_reports');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/procurement_profile');
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
            _navItem(context, 1, Icons.list, "Talepler"),
            _navItem(context, 2, Icons.add_circle_outline, "Teklif Ver"),
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
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.accent : AppColors.grey400,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.accent : AppColors.grey400,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
