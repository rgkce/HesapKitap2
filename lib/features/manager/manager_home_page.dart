import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/features/navigation/manager_navbar.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:intl/intl.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  List<RequestModel> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _requests = RequestService().getRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate Stats
    final totalRequests = _requests.length;
    final offersReceived =
        _requests.where((r) => r.status == RequestStatus.offersReceived).length;
    final pending =
        _requests.where((r) => r.status == RequestStatus.pending).length;
    final approved =
        _requests
            .where(
              (r) =>
                  r.status == RequestStatus.approved ||
                  r.status == RequestStatus.completed,
            )
            .length;

    final summaryStats = [
      {
        "label": "Toplam",
        "value": "$totalRequests",
        "color": AppColors.primary,
        "icon": Icons.assignment_outlined,
      },
      {
        "label": "Teklif",
        "value": "$offersReceived",
        "color": AppColors.info,
        "icon": Icons.local_offer_outlined,
      },
      {
        "label": "Bekleyen",
        "value": "$pending",
        "color": AppColors.warning,
        "icon": Icons.pending_actions_outlined,
      },
      {
        "label": "Onay",
        "value": "$approved",
        "color": AppColors.success,
        "icon": Icons.check_circle_outline_rounded,
      },
    ];

    // Dummy Trend Data
    final offerTrendData = [
      const FlSpot(0, 5),
      const FlSpot(1, 8),
      const FlSpot(2, 6),
      const FlSpot(3, 10),
      const FlSpot(4, 12),
      const FlSpot(5, 9),
      const FlSpot(6, 14),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Yönetici Paneli"),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Karşılama Metni
                  Text(
                    "Merhaba, ${UserService().currentUser?.name.split(' ').first ?? 'Yönetici'} 👋",
                    style: AppStyles.heading2.copyWith(
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Özet Kartlar
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: summaryStats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final stat = summaryStats[index];
                        return _buildStatCard(
                          stat["label"] as String,
                          stat["value"] as String,
                          stat["color"] as Color,
                          stat["icon"] as IconData,
                          isDark,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Son Talepler Başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Son Taleplerim",
                        style: AppStyles.heading2.copyWith(
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () =>
                                Navigator.pushNamed(context, '/manager_offers'),
                        child: Text(
                          "Tümü",
                          style: AppStyles.bodyTextBold.copyWith(
                            color:
                                isDark
                                    ? AppColors.textLight
                                    : AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_requests.isEmpty)
                    _buildEmptyState(isDark)
                  else
                    Column(
                      children:
                          _requests.take(3).map((req) {
                            return _buildRequestCard(req, isDark);
                          }).toList(),
                    ),

                  const SizedBox(height: 32),

                  /// Teklif Trend Grafiği
                  Text(
                    "İşlem Trendi",
                    style: AppStyles.heading2.copyWith(
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartContainer(
                    isDark: isDark,
                    child: SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: AppColors.accent,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                              spots: offerTrendData,
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.accent.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ManagerNavBar(currentIndex: 0),
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => Navigator.pushNamed(context, '/manager_createrequest'),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      width: 125,
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

  Widget _buildRequestCard(RequestModel req, bool isDark) {
    Color statusColor;
    String statusText;

    switch (req.status) {
      case RequestStatus.pending:
        statusColor = AppColors.warning;
        statusText = "Bekliyor";
        break;
      case RequestStatus.offersReceived:
        statusColor = AppColors.info;
        statusText = "Teklif";
        break;
      case RequestStatus.approved:
        statusColor = AppColors.success;
        statusText = "Onaylandı";
        break;
      case RequestStatus.rejected:
        statusColor = AppColors.error;
        statusText = "Red";
        break;
      case RequestStatus.completed:
        statusColor = AppColors.primary;
        statusText = "Bitti";
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          req.title,
          style: AppStyles.bodyTextBold.copyWith(
            color: isDark ? Colors.white : AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(req.createdAt),
          style: AppStyles.caption.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.assignment_late_outlined,
            size: 48,
            color: isDark ? AppColors.grey600 : AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            "Henüz talep oluşturmadınız.",
            style: AppStyles.bodyText.copyWith(
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
}
