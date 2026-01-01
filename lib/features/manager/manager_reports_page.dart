import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/manager_navbar.dart';

class ManagerReportsPage extends StatefulWidget {
  const ManagerReportsPage({super.key});

  @override
  State<ManagerReportsPage> createState() => _ManagerReportsPageState();
}

class _ManagerReportsPageState extends State<ManagerReportsPage> {
  String selectedFilter = "Son 7 gün";

  // Örnek veri
  final List<FlSpot> profitData = [
    const FlSpot(0, 200),
    const FlSpot(1, 300),
    const FlSpot(2, 250),
    const FlSpot(3, 400),
    const FlSpot(4, 350),
    const FlSpot(5, 450),
  ];

  final List<FlSpot> expenseData = [
    const FlSpot(0, 150),
    const FlSpot(1, 200),
    const FlSpot(2, 180),
    const FlSpot(3, 220),
    const FlSpot(4, 200),
    const FlSpot(5, 250),
  ];

  final List<FlSpot> netProfitData = [
    const FlSpot(0, 50),
    const FlSpot(1, 100),
    const FlSpot(2, 70),
    const FlSpot(3, 180),
    const FlSpot(4, 150),
    const FlSpot(5, 200),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text("Raporlar"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () {},
              icon: const Icon(Icons.share_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Özet Veriler",
                      style: AppStyles.heading2.copyWith(
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    _buildFilterDropdown(isDark),
                  ],
                ),
                const SizedBox(height: 20),

                /// Özet Kartlar
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSummaryCard(
                        "Toplam Teklif",
                        "45",
                        Icons.list_alt,
                        AppColors.info,
                        isDark,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        "Kabul Edilen",
                        "30",
                        Icons.check_circle_outline_rounded,
                        AppColors.success,
                        isDark,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        "Reddedilen",
                        "10",
                        Icons.cancel_outlined,
                        AppColors.error,
                        isDark,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        "Bekleyen",
                        "5",
                        Icons.pending_actions_outlined,
                        AppColors.warning,
                        isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                /// Kar / Gider / Net Kar Grafiği
                Text(
                  "Finansal Durum",
                  style: AppStyles.heading2.copyWith(
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildChartContainer(
                  isDark: isDark,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  reservedSize: 30,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              _lineSeries(profitData, AppColors.success),
                              _lineSeries(expenseData, AppColors.error),
                              _lineSeries(netProfitData, AppColors.info),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendDot(AppColors.success, "Gelir", isDark),
                          const SizedBox(width: 16),
                          _buildLegendDot(AppColors.error, "Gider", isDark),
                          const SizedBox(width: 16),
                          _buildLegendDot(AppColors.info, "Net Kar", isDark),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const ManagerNavBar(currentIndex: 3),
      ),
    );
  }

  LineChartBarData _lineSeries(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.05)),
      spots: spots,
    );
  }

  Widget _buildFilterDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 4,
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedFilter,
        dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
        items:
            ["Son 7 gün", "Son 1 ay", "Tüm Veriler"]
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: AppStyles.caption.copyWith(
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: (value) => setState(() => selectedFilter = value!),
        underline: const SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: isDark ? Colors.white : AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: AppStyles.heading2.copyWith(
              color: isDark ? Colors.white : AppColors.textDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppStyles.caption.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLegendDot(Color color, String label, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppStyles.caption.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
        ),
      ],
    );
  }
}
