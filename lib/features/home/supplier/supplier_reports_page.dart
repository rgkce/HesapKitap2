import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/features/navigation/supplier_navbar.dart';

class SupplierReportsPage extends StatelessWidget {
  const SupplierReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedFilter = "Son 7 gün";

    // Örnek istatistikler
    final summaryStats = [
      {"label": "Toplam Teklif", "value": "50"},
      {"label": "Kabul Edilen", "value": "35"},
      {"label": "Reddedilen", "value": "10"},
      {"label": "Bekleyen", "value": "5"},
    ];

    // Gelir / Gider / Net Kar verileri
    final profitData = [
      FlSpot(0, 200),
      FlSpot(1, 300),
      FlSpot(2, 500),
      FlSpot(3, 400),
      FlSpot(4, 700),
      FlSpot(5, 600),
      FlSpot(6, 800),
    ];

    final expenseData = [
      FlSpot(0, 150),
      FlSpot(1, 200),
      FlSpot(2, 300),
      FlSpot(3, 250),
      FlSpot(4, 400),
      FlSpot(5, 350),
      FlSpot(6, 500),
    ];

    final netProfitData = [
      FlSpot(0, 50),
      FlSpot(1, 100),
      FlSpot(2, 200),
      FlSpot(3, 150),
      FlSpot(4, 300),
      FlSpot(5, 250),
      FlSpot(6, 300),
    ];

    // Örnek top teklifler
    final topOffers = [
      {"title": "Ofis Malzemeleri", "value": "1500 ₺"},
      {"title": "Temizlik Ürünleri", "value": "1200 ₺"},
      {"title": "Bilgisayar Donanımı", "value": "5000 ₺"},
    ];

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
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
                    /// Başlık ve İndirme Butonları
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Tedarikçi Raporlar",
                          style: AppStyles.heading1.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    /// Filtreler
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: selectedFilter,
                          dropdownColor: AppColors.grey800,
                          items:
                              ["Son 7 gün", "Son 1 ay", "Tüm Teklifler"]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: AppStyles.bodyText.copyWith(
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            // burada filtreleme işlemini yapabilirsiniz
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // PDF indir
                              },
                              icon: Icon(
                                Icons.picture_as_pdf,
                                color: AppColors.textLight,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Excel indir
                              },
                              icon: Icon(
                                Icons.file_download,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// İstatistikler
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
                            _getIconForStat(stat["label"]!),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Kar / Gider / Net Kar Grafiği
                    Text(
                      "Gelir / Gider / Net Kar",
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 600,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 100,
                                getDrawingHorizontalLine:
                                    (value) => FlLine(
                                      color: AppColors.grey200.withOpacity(0.3),
                                      strokeWidth: 1,
                                    ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 100,
                                    reservedSize: 40,
                                    getTitlesWidget:
                                        (value, _) => Text(
                                          value.toInt().toString(),
                                          style: AppStyles.bodyText.copyWith(
                                            color: AppColors.textLight
                                                .withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                        ),
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
                                            color: AppColors.textLight
                                                .withOpacity(0.7),
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
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.textLight.withOpacity(0.5),
                                  ),
                                  left: BorderSide(
                                    color: AppColors.textLight.withOpacity(0.5),
                                  ),
                                  right: BorderSide(color: Colors.transparent),
                                  top: BorderSide(color: Colors.transparent),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: AppColors.success,
                                  barWidth: 4,
                                  spots: profitData,
                                ),
                                LineChartBarData(
                                  isCurved: true,
                                  color: AppColors.error,
                                  barWidth: 4,
                                  spots: expenseData,
                                ),
                                LineChartBarData(
                                  isCurved: true,
                                  color: AppColors.accent,
                                  barWidth: 4,
                                  spots: netProfitData,
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        "${spot.y.toInt()} ₺",
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                                handleBuiltInTouches: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildLegendItem(AppColors.success, "Gelir"),
                        const SizedBox(width: 16),
                        _buildLegendItem(AppColors.error, "Gider"),
                        const SizedBox(width: 16),
                        _buildLegendItem(AppColors.accent, "Net Kar"),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// Teklif Durumu Pasta Grafiği
                    Text(
                      "Teklif Durumu",
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 50,
                          pieTouchData: PieTouchData(enabled: true),
                          sections: [
                            PieChartSectionData(
                              value: 35,
                              color: AppColors.success,
                              radius: 65,
                              title: "%70",
                              titleStyle: AppStyles.bodyTextBold.copyWith(
                                color: AppColors.grey100,
                                fontSize: 20,
                              ),
                            ),
                            PieChartSectionData(
                              value: 10,
                              color: AppColors.error,
                              radius: 65,
                              title: "%20",
                              titleStyle: AppStyles.bodyTextBold.copyWith(
                                color: AppColors.grey100,
                                fontSize: 20,
                              ),
                            ),
                            PieChartSectionData(
                              value: 5,
                              color: AppColors.warning,
                              radius: 65,
                              title: "%10",
                              titleStyle: AppStyles.bodyTextBold.copyWith(
                                color: AppColors.grey100,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildLegend(AppColors.success, "Kabul edilen"),
                        const SizedBox(width: 16),
                        _buildLegend(AppColors.error, "Reddedilen"),
                        const SizedBox(width: 16),
                        _buildLegend(AppColors.warning, "Bekleyen"),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// Top Teklifler
                    Text(
                      "Top Teklifler",
                      style: AppStyles.heading2.copyWith(
                        color: AppColors.textLight,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: topOffers.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final offer = topOffers[index];
                          final gradientColors = [
                            AppColors.info.withOpacity(0.8),
                            AppColors.accent.withOpacity(0.8),
                          ];

                          return Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors.last.withOpacity(0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: AppColors.secondary,
                                  size: 28,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  offer["title"]!,
                                  style: AppStyles.bodyTextBold.copyWith(
                                    color: AppColors.textLight,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  offer["value"]!,
                                  style: AppStyles.bodyTextBold.copyWith(
                                    color: AppColors.success,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const SupplierNavBar(currentIndex: 4),
      ),
    );
  }

  //Pie Chart yardımcı
  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppStyles.bodyText.copyWith(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Legend için yardımcı fonksiyon
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppStyles.bodyText.copyWith(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Yeni tasarımlı istatistik kartı
  Widget _buildColoredStatCard(
    String label,
    String value,
    List<Color> gradientColors,
    IconData icon,
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
          Row(
            children: [
              const SizedBox(width: 20),
              Icon(icon, color: AppColors.grey100, size: 25),
              const SizedBox(width: 20),
              Text(
                value,
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.grey100,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppStyles.bodyTextBold.copyWith(
              color: AppColors.grey100,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Label'a göre ikon seçici
  IconData _getIconForStat(String label) {
    switch (label) {
      case "Toplam Teklif":
        return Icons.list_alt;
      case "Kabul Edilen":
        return Icons.check_circle;
      case "Reddedilen":
        return Icons.cancel;
      case "Bekleyen":
        return Icons.pending_actions;
      default:
        return Icons.info;
    }
  }
}
