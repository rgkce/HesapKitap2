import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/supplier_navbar.dart';

class SupplierHomePage extends StatelessWidget {
  const SupplierHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final pendingRequests = [
      {"title": "Ofis Malzemeleri Talebi", "status": "Onay Bekliyor"},
      {"title": "Temizlik Ürünleri Talebi", "status": "Cevaplanmadı"},
      {"title": "Laptop Satın Alımı", "status": "Onaylandı"},
      {"title": "Monitör Satın Alımı", "status": "Reddedildi"},
    ];

    final summaryStats = [
      {"label": "Verilen Teklif", "value": "24", "color": AppColors.secondary},
      {"label": "Onaylanan", "value": "15", "color": AppColors.success},
      {"label": "Reddedilen", "value": "5", "color": AppColors.error},
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tedarikçi Ana Sayfa",
                            style: AppStyles.heading1.copyWith(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/supplier_profile');
                            },
                            icon: Icon(
                              Icons.settings,
                              color: AppColors.textLight,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Renkli istatistik kutuları
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: summaryStats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final stat = summaryStats[index];
                        return _buildStatCard(
                          stat["label"].toString(),
                          stat["value"].toString(),
                          stat["color"] as Color,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Kar/Zarar Grafiği
                  Text(
                    "Kar / Zarar Grafiği",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 200, child: _ProfitLossChart()),
                  const SizedBox(height: 25),

                  // Bekleyen Talepler
                  Text(
                    "Bekleyen Talepler",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: pendingRequests.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final req = pendingRequests[index];
                        return _buildRequestCard(req["title"]!, req["status"]!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const SupplierNavBar(currentIndex: 0),
      ),
    );
  }

  // Renkli İstatistik Kutusu
  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
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
            style: const TextStyle(
              color: AppColors.grey100,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.grey200, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Talep kartı (duruma göre renkli ikon)
  Widget _buildRequestCard(String title, String status) {
    Color statusColor = AppColors.secondary;
    IconData statusIcon = Icons.pending_actions;

    if (status.contains("Onaylandı")) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
    } else if (status.contains("Reddedildi")) {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.grey100,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Kar/Zarar Grafiği
class _ProfitLossChart extends StatelessWidget {
  const _ProfitLossChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: AppColors.grey200, fontSize: 15);
                switch (value.toInt()) {
                  case 0:
                    return const Text("Oca", style: style);
                  case 1:
                    return const Text("Şub", style: style);
                  case 2:
                    return const Text("Mar", style: style);
                  case 3:
                    return const Text("Nis", style: style);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 12, color: AppColors.success, width: 18),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 8, color: AppColors.error, width: 18),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 15, color: AppColors.success, width: 18),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 5, color: AppColors.error, width: 18),
            ],
          ),
        ],
      ),
    );
  }
}
