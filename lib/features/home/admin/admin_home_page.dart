import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Geri butonunu engellemek için WillPopScope kullanıyoruz
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Admin Ana Sayfa",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // KPI Kartları
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      _buildKpiCard(
                        icon: Icons.pending_actions,
                        label: "Bekleyen Talepler",
                        value: "12",
                        color: AppColors.warning,
                      ),
                      _buildKpiCard(
                        icon: Icons.check_circle,
                        label: "Onaylanan Talepler",
                        value: "34",
                        color: AppColors.success,
                      ),
                      _buildKpiCard(
                        icon: Icons.attach_money,
                        label: "Toplam Sipariş Tutarı",
                        value: "₺125.000",
                        color: AppColors.info,
                      ),
                      _buildKpiCard(
                        icon: Icons.local_shipping,
                        label: "Tedarikçi Performansı",
                        value: "%89",
                        color: AppColors.secondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Bekleyen Talepler Listesi (örnek)
                  Text(
                    "Bekleyen Talepler",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRequestCard(
                    "PR-2025-001",
                    "Laptop Talebi",
                    "Orta",
                    "Satınalma",
                  ),
                  _buildRequestCard(
                    "PR-2025-002",
                    "Ofis Masası",
                    "Yüksek",
                    "İdari",
                  ),
                  _buildRequestCard(
                    "PR-2025-003",
                    "Yazılım Lisansı",
                    "Düşük",
                    "IT",
                  ),

                  const SizedBox(height: 30),

                  // Grafikler ve Analitik (placeholder)
                  Text(
                    "Grafikler",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.grey800.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Harcama Dağılımı Grafiği Placeholder",
                        style: TextStyle(color: AppColors.grey100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.grey800.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Aylık Harcama Trend Grafiği Placeholder",
                        style: TextStyle(color: AppColors.grey100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.grey100, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppStyles.heading2.copyWith(color: AppColors.grey100),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(color: AppColors.grey200),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    String prNo,
    String title,
    String priority,
    String department,
  ) {
    Color priorityColor;
    switch (priority) {
      case "Yüksek":
        priorityColor = AppColors.error;
        break;
      case "Orta":
        priorityColor = AppColors.info;
        break;
      default:
        priorityColor = AppColors.secondary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prNo,
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: AppStyles.bodyText.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priority,
                style: AppStyles.bodyTextBold.copyWith(color: priorityColor),
              ),
              const SizedBox(height: 5),
              Text(
                department,
                style: AppStyles.bodyText.copyWith(color: AppColors.textLight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
