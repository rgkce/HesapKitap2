import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/services/api_service.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  bool _isLoading = true;
  bool _isBackendData = false;

  // Rapor Değerleri
  int _toplamSiparis = 0;
  int _bekleyen = 0;
  double _toplamHarcama = 0;
  double _performans = 0; // Ortalama Onay Süresi (Saat) veya Yüzde

  List<PieChartSectionData> _pieSections = [];
  List<FlSpot> _lineSpots = [];

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() => _isLoading = true);

    // 1. Backend'den veri çekmeyi dene
    final apiService = ApiService();
    final summary = await apiService.fetchRequestSummary();
    final spending = await apiService.fetchMonthlySpending();
    final performance = await apiService.fetchSupplierPerformance();
    final duration = await apiService.fetchApprovalDuration();

    if (summary != null && spending != null) {
      // Backend başarılı
      setState(() {
        _isBackendData = true;
        _toplamSiparis = summary['total'] ?? 0;
        _bekleyen = summary['pending'] ?? 0;
        
        // Harcama toplamı
        double spendSum = 0;
        for (var item in spending) {
          final amt = item['totalAmount'];
          spendSum += amt is num ? amt.toDouble() : double.tryParse(amt.toString()) ?? 0.0;
        }
        _toplamHarcama = spendSum;

        // Performans: Onay süresi varsa saat olarak göster
        _performans = (duration?['averageHours'] as num?)?.toDouble() ?? 0.0;

        // Pie Chart: Tedarikçiye göre harcama dağılımı (veya teklif sayısı)
        if (performance != null && performance.isNotEmpty) {
          int index = 0;
          final List<Color> colors = [
            AppColors.primary,
            AppColors.accent,
            AppColors.info,
            AppColors.warning,
            AppColors.success
          ];
          _pieSections = performance.map<PieChartSectionData>((item) {
            final approved = int.tryParse(item['approvedOffers']?.toString() ?? '0') ?? 0;
            final rejected = int.tryParse(item['rejectedOffers']?.toString() ?? '0') ?? 0;
            final total = approved + rejected;
            final val = total > 0 ? total.toDouble() : 1.0;
            final color = colors[index % colors.length];
            index++;

            return PieChartSectionData(
              color: color,
              value: val,
              title: item['supplierName'] ?? 'Tedarikçi',
              radius: 50,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            );
          }).toList();
        } else {
          _pieSections = [
            PieChartSectionData(
              color: AppColors.primary,
              value: 100,
              title: 'Veri Yok',
              radius: 50,
              titleStyle: const TextStyle(color: Colors.white),
            )
          ];
        }

        // Line Chart: Aylık Trend
        _lineSpots = [];
        for (int i = 0; i < spending.length; i++) {
          final amt = spending[i]['totalAmount'];
          final double val = amt is num ? amt.toDouble() : double.tryParse(amt.toString()) ?? 0.0;
          _lineSpots.add(FlSpot(i.toDouble(), val / 1000.0)); // K cinsinden göster
        }
        if (_lineSpots.isEmpty) {
          _lineSpots = [const FlSpot(0, 0), const FlSpot(5, 0)];
        }

        _isLoading = false;
      });
      return;
    }

    // 2. Fallback: Yerel mock veritabanından hesapla
    final requests = RequestService().getRequests();
    setState(() {
      _isBackendData = false;
      
      // Siparişler: ordered ve completed olanlar
      _toplamSiparis = requests.where((r) => r.status == RequestStatus.ordered || r.status == RequestStatus.completed).length;
      
      // Bekleyenler: pending ve offersReceived olanlar
      _bekleyen = requests.where((r) => r.status == RequestStatus.pending || r.status == RequestStatus.offersReceived).length;

      // Toplam harcama
      _toplamHarcama = requests
          .where((r) => r.status == RequestStatus.ordered || r.status == RequestStatus.completed)
          .fold(0.0, (sum, r) {
        final selectedOffer = r.offers.firstWhere(
          (o) => o.isSelected,
          orElse: () => OfferModel(id: '', requestId: '', supplierName: '', price: 0, currency: '', description: ''),
        );
        if (selectedOffer.currency == "TL") {
          return sum + (selectedOffer.price * r.quantity);
        }
        return sum;
      });

      // Performans (Yerel mock değer)
      _performans = 89.0;

      // Pasta grafik: Statü Dağılımı
      final approvedCount = requests.where((r) => r.status == RequestStatus.approved).length;
      final rejectedCount = requests.where((r) => r.status == RequestStatus.rejected).length;

      _pieSections = [
        PieChartSectionData(
          color: AppColors.primary,
          value: _bekleyen.toDouble() > 0 ? _bekleyen.toDouble() : 1.0,
          title: 'Bekleyen',
          radius: 50,
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        PieChartSectionData(
          color: AppColors.success,
          value: approvedCount.toDouble() > 0 ? approvedCount.toDouble() : 1.0,
          title: 'Onaylı',
          radius: 50,
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
        PieChartSectionData(
          color: AppColors.error,
          value: rejectedCount.toDouble() > 0 ? rejectedCount.toDouble() : 1.0,
          title: 'Reddedildi',
          radius: 50,
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ];

      // Çizgi grafik: Mock Harcama Dağılımı
      _lineSpots = [
        const FlSpot(0, 3),
        const FlSpot(1, 1),
        const FlSpot(2, 4),
        const FlSpot(3, 2),
        const FlSpot(4, 5),
        FlSpot(5, _toplamHarcama / 1000.0), // K cinsinden son değer
      ];

      _isLoading = false;
    });
  }

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
              icon: const Icon(Icons.refresh),
              onPressed: _loadReportData,
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadReportData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Backend verisi gösterilip gösterilmediğini belirten etiket
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isBackendData ? "Gerçek API Verileri" : "Yerel Mock Veriler",
                              style: AppStyles.caption.copyWith(
                                color: _isBackendData ? AppColors.success : AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // KPI Cards Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildKpiCard(
                                context,
                                title: _isBackendData ? "Toplam Talep" : "Toplam Sipariş",
                                value: "$_toplamSiparis",
                                icon: Icons.shopping_cart_outlined,
                                color: AppColors.primary,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildKpiCard(
                                context,
                                title: "Bekleyen",
                                value: "$_bekleyen",
                                icon: Icons.pending_actions_outlined,
                                color: AppColors.warning,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildKpiCard(
                                context,
                                title: "Toplam Gider",
                                value: "₺${_toplamHarcama >= 1000 ? '${(_toplamHarcama / 1000).toStringAsFixed(1)}K' : _toplamHarcama.toStringAsFixed(0)}",
                                icon: Icons.payments_outlined,
                                color: AppColors.success,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildKpiCard(
                                context,
                                title: _isBackendData ? "Onay Süresi" : "Performans",
                                value: _isBackendData
                                    ? "${_performans.toStringAsFixed(1)} sa"
                                    : "%${_performans.toStringAsFixed(0)}",
                                icon: Icons.speed_outlined,
                                color: AppColors.accent,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Charts Section
                        Text(
                          _isBackendData ? "Tedarikçi Dağılımı" : "Talep Dağılımı",
                          style: AppStyles.heading2.copyWith(
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildChartContainer(
                          isDark: isDark,
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 40,
                                sections: _pieSections,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        Text(
                          _isBackendData ? "Aylık Harcama Trendi (Bin ₺)" : "Aylık Harcama Trendi",
                          style: AppStyles.heading2.copyWith(
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildChartContainer(
                          isDark: isDark,
                          child: AspectRatio(
                            aspectRatio: 1.7,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: false),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _lineSpots,
                                    isCurved: true,
                                    color: AppColors.accent,
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(show: false),
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
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppStyles.heading2.copyWith(
              color: isDark ? Colors.white : AppColors.textDark,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
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
}
