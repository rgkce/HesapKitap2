import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDark
                      ? [AppColors.grey800, AppColors.primary.withOpacity(0.8)]
                      : [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.accent.withOpacity(0.8),
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Raporlar",
                        style: AppStyles.heading1.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildReportCard("Toplam Sipariş", "152"),
                    _buildReportCard("Onay Bekleyen Talepler", "12"),
                    _buildReportCard("Toplam Harcama", "₺125.000"),
                    _buildReportCard("Tedarikçi Performansı", "%89"),
                    const SizedBox(height: 30),
                    Text(
                      "Grafikler",
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildGraphPlaceholder("Harcama Dağılımı"),
                    const SizedBox(height: 15),
                    _buildGraphPlaceholder("Aylık Harcama Trend"),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildReportCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.bodyText.copyWith(color: AppColors.textLight),
          ),
          Text(
            value,
            style: AppStyles.bodyTextBold.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphPlaceholder(String title) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          title,
          style: AppStyles.bodyTextBold.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
