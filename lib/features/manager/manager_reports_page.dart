import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/manager_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/core/services/api_service.dart';

class ManagerReportsPage extends StatefulWidget {
  const ManagerReportsPage({super.key});

  @override
  State<ManagerReportsPage> createState() => _ManagerReportsPageState();
}

class _ManagerReportsPageState extends State<ManagerReportsPage> {
  String selectedFilter = "Son 7 gün";
  bool _isLoading = true;
  bool _isBackendData = false;

  int _toplamTeklif = 0;
  int _kabulEdilen = 0;
  int _reddedilen = 0;
  int _bekleyen = 0;
  double _toplamGider = 0;
  List<FlSpot> _lineSpots = [];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // 1. Backend'den veri çekmeyi dene
    final apiService = ApiService();
    final summary = await apiService.fetchRequestSummary();
    final spending = await apiService.fetchMonthlySpending();
    final performance = await apiService.fetchSupplierPerformance();

    if (summary != null && spending != null) {
      setState(() {
        _isBackendData = true;
        
        // Toplam Teklif sayısını tedarikçi performansından topla
        if (performance != null) {
          _toplamTeklif = performance.fold<int>(0, (sum, item) {
            final approved = int.tryParse(item['approvedOffers']?.toString() ?? '0') ?? 0;
            final rejected = int.tryParse(item['rejectedOffers']?.toString() ?? '0') ?? 0;
            return sum + approved + rejected;
          });
        } else {
          _toplamTeklif = 0;
        }

        _kabulEdilen = summary['approved'] ?? 0;
        _reddedilen = summary['rejected'] ?? 0;
        _bekleyen = summary['pending'] ?? 0;

        double spendSum = 0;
        for (var item in spending) {
          final amt = item['totalAmount'];
          spendSum += amt is num ? amt.toDouble() : double.tryParse(amt.toString()) ?? 0.0;
        }
        _toplamGider = spendSum;

        // Line Chart spots
        _lineSpots = [];
        for (int i = 0; i < spending.length; i++) {
          final amt = spending[i]['totalAmount'];
          final double val = amt is num ? amt.toDouble() : double.tryParse(amt.toString()) ?? 0.0;
          _lineSpots.add(FlSpot(i.toDouble(), val));
        }
        if (_lineSpots.isEmpty) {
          _lineSpots = [const FlSpot(0, 0), const FlSpot(5, 0)];
        }

        _isLoading = false;
      });
      return;
    }

    // 2. Fallback: Yerel mock veritabanı hesaplaması
    final requests = RequestService().getRequests();
    setState(() {
      _isBackendData = false;
      _toplamTeklif = requests.fold(0, (sum, r) => sum + r.offers.length);
      _kabulEdilen = requests.where((r) => r.status == RequestStatus.approved || r.status == RequestStatus.ordered || r.status == RequestStatus.completed).length;
      _reddedilen = requests.where((r) => r.status == RequestStatus.rejected).length;
      _bekleyen = requests.where((r) => r.status == RequestStatus.pending || r.status == RequestStatus.offersReceived).length;
      
      _toplamGider = requests.where((r) => r.status == RequestStatus.ordered || r.status == RequestStatus.completed).fold(0.0, (sum, r) {
        final selectedOffer = r.offers.firstWhere((o) => o.isSelected, orElse: () => OfferModel(id: '', requestId: '', supplierName: '', price: 0, currency: '', description: ''));
        if (selectedOffer.currency == "TL") {
          return sum + (selectedOffer.price * r.quantity);
        }
        return sum;
      });

      _lineSpots = [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        FlSpot(5, _toplamGider),
      ];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacementNamed(context, '/manager_home');
      },
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
              onPressed: _loadData,
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                "$_toplamTeklif",
                                Icons.list_alt,
                                AppColors.info,
                                isDark,
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "Kabul Edilen",
                                "$_kabulEdilen",
                                Icons.check_circle_outline_rounded,
                                AppColors.success,
                                isDark,
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "Reddedilen",
                                "$_reddedilen",
                                Icons.cancel_outlined,
                                AppColors.error,
                                isDark,
                              ),
                              const SizedBox(width: 12),
                              _buildSummaryCard(
                                "Bekleyen",
                                "$_bekleyen",
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
                                      _lineSeries(_lineSpots, AppColors.error),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegendDot(AppColors.error, "Toplam Harcama (₺${_toplamGider.toStringAsFixed(0)})", isDark),
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
