import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/home/approver/widgets/hk_buttons.dart';
import 'package:hesapkitap/features/navigation/approver_navbar.dart';

class ApproverReportsPage extends StatelessWidget {
  const ApproverReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                    Text(
                      "Raporlar",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Özet Kartlar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            "Toplam Gelir",
                            "₺12.500",
                            AppColors.success,
                            Icons.arrow_upward,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            "Toplam Gider",
                            "₺8.200",
                            AppColors.error,
                            Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildSummaryCard(
                      "Net Kâr",
                      "₺4.300",
                      AppColors.primary,
                      Icons.show_chart,
                    ),
                    // Pasta Grafik Kartı
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.grey100.withOpacity(
                          0.7,
                        ), // yarı saydam
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Gelir - Gider Dağılımı",
                            style: AppStyles.heading3.copyWith(
                              color: AppColors.grey800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 150,
                            child: PieChart(
                              PieChartData(
                                borderData: FlBorderData(show: false),
                                centerSpaceRadius: 24,
                                sectionsSpace: 4,
                                sections: [
                                  PieChartSectionData(
                                    value: 60,
                                    title: "60%",
                                    radius: 70,
                                    color: AppColors.success,
                                    titleStyle: AppStyles.bodyText.copyWith(
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 40,
                                    title: "40%",
                                    radius: 70,
                                    color: AppColors.error,
                                    titleStyle: AppStyles.bodyText.copyWith(
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // PieChart (Açıklama)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _legendItem(AppColors.success, "Gelir"),
                              const SizedBox(width: 20),
                              _legendItem(AppColors.error, "Gider"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Filtre Butonları
                    Row(
                      children: [
                        Expanded(
                          child: HKGradientButton(
                            icon: Icons.date_range,
                            label: "Tarih Aralığı Seç",
                            onPressed: () {
                              /* date range picker */
                            },
                            colors:
                                isDark
                                    ? [
                                      AppColors.primary.withOpacity(0.8),
                                      AppColors.accent.withOpacity(0.8),
                                    ]
                                    : [AppColors.primary, AppColors.accent],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: HKGradientButton(
                            icon: Icons.filter_list,
                            label: "Kategoriler",
                            onPressed: () {
                              /* filter sheet */
                            },
                            colors:
                                isDark
                                    ? [
                                      AppColors.accent.withOpacity(0.8),
                                      AppColors.warning.withOpacity(0.8),
                                    ]
                                    : [AppColors.accent, AppColors.warning],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Export Butonları
                    Row(
                      children: [
                        Expanded(
                          child: HKGradientButton(
                            icon: Icons.picture_as_pdf,
                            label: "PDF Dışa Aktar",
                            onPressed: () {
                              /* export pdf */
                            },
                            colors:
                                isDark
                                    ? [
                                      AppColors.error.withOpacity(0.8),
                                      AppColors.secondary.withOpacity(0.8),
                                    ]
                                    : [AppColors.error, AppColors.secondary],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: HKGradientButton(
                            icon: Icons.table_chart,
                            label: "Excel Dışa Aktar",
                            onPressed: () {
                              /* export excel */
                            },
                            colors:
                                isDark
                                    ? [
                                      AppColors.secondary.withOpacity(0.8),
                                      AppColors.success.withOpacity(0.8),
                                    ]
                                    : [AppColors.secondary, AppColors.success],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ApproverNavBar(currentIndex: 3),
      ),
    );
  }

  //Kartlar
  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon kısmı
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),

          // Metin kısmı
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🔹 PieChart Açıklama Widget
Widget _legendItem(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(text, style: AppStyles.bodyText.copyWith(color: AppColors.grey600)),
    ],
  );
}
