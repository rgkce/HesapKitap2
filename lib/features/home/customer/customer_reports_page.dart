import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/customer_navbar.dart';

class CustomerReportsPage extends StatefulWidget {
  const CustomerReportsPage({super.key});

  @override
  State<CustomerReportsPage> createState() => _CustomerReportsPageState();
}

class _CustomerReportsPageState extends State<CustomerReportsPage> {
  String selectedFilter = "Son 7 gün";

  // Örnek veri
  final List<FlSpot> profitData = [
    FlSpot(0, 200),
    FlSpot(1, 300),
    FlSpot(2, 250),
    FlSpot(3, 400),
    FlSpot(4, 350),
    FlSpot(5, 450),
  ];

  final List<FlSpot> expenseData = [
    FlSpot(0, 150),
    FlSpot(1, 200),
    FlSpot(2, 180),
    FlSpot(3, 220),
    FlSpot(4, 200),
    FlSpot(5, 250),
  ];

  final List<FlSpot> netProfitData = [
    FlSpot(0, 50),
    FlSpot(1, 100),
    FlSpot(2, 70),
    FlSpot(3, 180),
    FlSpot(4, 150),
    FlSpot(5, 200),
  ];

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
                      : [AppColors.primary.withOpacity(0.8), AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Center(
                    child: Text(
                      "Raporlar",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Filtre Seçimi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: selectedFilter,
                        dropdownColor: AppColors.grey800,
                        items:
                            ["Son 7 gün", "Son 1 ay", "Tüm Veriler"]
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
                          setState(() {
                            selectedFilter = value!;
                          });
                        },
                      ),

                      /// PDF / Excel İndirme Butonları
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // PDF indirme işlemi
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              size: 20,
                              color: AppColors.grey100,
                            ),
                            label: Text(
                              "PDF",
                              style: AppStyles.bodyTextBold.copyWith(
                                color: AppColors.grey100,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Excel indirme işlemi
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.table_chart,
                              size: 20,
                              color: AppColors.grey100,
                            ),
                            label: Text(
                              "Excel",
                              style: AppStyles.bodyTextBold.copyWith(
                                color: AppColors.grey100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Özet Kartlar
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSummaryCard(
                          "Toplam Teklif",
                          "45",
                          Icons.list_alt,
                          AppColors.accent,
                        ),
                        _buildSummaryCard(
                          "Kabul Edilen",
                          "30",
                          Icons.check_circle,
                          AppColors.success,
                        ),
                        _buildSummaryCard(
                          "Reddedilen",
                          "10",
                          Icons.cancel,
                          AppColors.error,
                        ),
                        _buildSummaryCard(
                          "Bekleyen",
                          "5",
                          Icons.pending_actions,
                          AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Kar / Gider / Net Kar Grafiği
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Grafik Başlığı
                        Text(
                          "Kar / Gider / Net Kar",
                          style: AppStyles.heading2.copyWith(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// Grafik
                        SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: 600, // genişliği artırdık
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 100,
                                    getDrawingHorizontalLine:
                                        (value) => FlLine(
                                          color: AppColors.grey200.withOpacity(
                                            0.3,
                                          ),
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
                                              style: AppStyles.bodyText
                                                  .copyWith(
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
                                              style: AppStyles.bodyText
                                                  .copyWith(
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
                                        color: AppColors.textLight.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      left: BorderSide(
                                        color: AppColors.textLight.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      right: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      top: BorderSide(
                                        color: Colors.transparent,
                                      ),
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
                                    handleBuiltInTouches: true,
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
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Legend / Açıklamalar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildLegendDot(AppColors.success, "Gelir"),
                            const SizedBox(width: 16),
                            _buildLegendDot(AppColors.error, "Gider"),
                            const SizedBox(width: 16),
                            _buildLegendDot(AppColors.accent, "Net Kar"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomerNavBar(currentIndex: 3),
      ),
    );
  }

  /// Özet kart tasarımı
  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: 12),
              Text(
                value,
                style: AppStyles.heading2.copyWith(
                  color: AppColors.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Legend Dot Fonksiyonu
  Widget _buildLegendDot(Color color, String label) {
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
