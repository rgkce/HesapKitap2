import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/features/navigation/customer_navbar.dart';

class CustomerDashboardPage extends StatelessWidget {
  const CustomerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final summaryStats = [
      {"label": "Gelen Teklif", "value": "58"},
      {"label": "Onaylanan", "value": "34"},
      {"label": "Reddedilen", "value": "12"},
      {"label": "Bekleyen", "value": "12"},
    ];

    final recentOffers = [
      {"supplier": "ABC Ltd.", "price": "₺12.500", "date": "02/09/2025"},
      {"supplier": "XYZ A.Ş.", "price": "₺8.200", "date": "01/09/2025"},
      {"supplier": "LMN Tekstil", "price": "₺15.000", "date": "30/08/2025"},
    ];

    final offerTrendData = [
      FlSpot(0, 5),
      FlSpot(1, 8),
      FlSpot(2, 6),
      FlSpot(3, 10),
      FlSpot(4, 12),
      FlSpot(5, 9),
      FlSpot(6, 14),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isDark
                    ? [AppColors.grey800, AppColors.primary.withOpacity(0.8)]
                    : [AppColors.primary.withOpacity(0.8), AppColors.accent],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Satınalma Ana Sayfa",
                        style: AppStyles.heading1.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/customer_profile');
                        },
                        icon: Icon(
                          Icons.settings,
                          color: AppColors.textLight,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// Özet Kartlar
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: summaryStats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final stat = summaryStats[index];
                        final colors = [
                          isDark
                              ? [
                                AppColors.info.withOpacity(0.8),
                                AppColors.accent.withOpacity(0.8),
                              ]
                              : [AppColors.info, AppColors.accent],
                          isDark
                              ? [
                                AppColors.accent.withOpacity(0.8),
                                AppColors.success.withOpacity(0.8),
                              ]
                              : [AppColors.accent, AppColors.success],
                          isDark
                              ? [
                                AppColors.success.withOpacity(0.8),
                                AppColors.secondary.withOpacity(0.8),
                              ]
                              : [AppColors.success, AppColors.secondary],
                          isDark
                              ? [
                                AppColors.secondary.withOpacity(0.8),
                                AppColors.warning.withOpacity(0.8),
                              ]
                              : [AppColors.secondary, AppColors.warning],
                        ];
                        return _buildColoredStatCard(
                          stat["label"]!,
                          stat["value"]!,
                          colors[index % colors.length],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Son Teklifler
                  Text(
                    "Son Teklifler",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children:
                        recentOffers.map((offer) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.grey600.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  offer["supplier"]!,
                                  style: AppStyles.bodyTextBold.copyWith(
                                    color: AppColors.grey100,
                                    fontSize: 18,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      offer["price"]!,
                                      style: AppStyles.bodyTextBold.copyWith(
                                        color: AppColors.info,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      offer["date"]!,
                                      style: AppStyles.bodyText.copyWith(
                                        color: AppColors.grey100,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 30),

                  /// Teklif Trend Grafiği
                  Text(
                    "Teklif Trendleri",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget:
                                  (value, _) => Text(
                                    "G${value.toInt() + 1}",
                                    style: AppStyles.bodyText.copyWith(
                                      color: AppColors.grey100,
                                      fontSize: 12,
                                    ),
                                  ),
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: AppColors.success,
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.success.withOpacity(0.2),
                            ),
                            dotData: FlDotData(show: true),
                            spots: offerTrendData,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomerNavBar(currentIndex: 0),
    );
  }

  /// İstatistik Kartı
  Widget _buildColoredStatCard(
    String label,
    String value,
    List<Color> gradientColors,
  ) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppStyles.heading2.copyWith(
              color: AppColors.grey100,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppStyles.bodyTextBold.copyWith(
              color: AppColors.grey100,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
