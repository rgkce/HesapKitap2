import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/procurement_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/core/services/api_service.dart';

class ProcurementReportsPage extends StatefulWidget {
  const ProcurementReportsPage({super.key});

  @override
  State<ProcurementReportsPage> createState() => _ProcurementReportsPageState();
}

class _ProcurementReportsPageState extends State<ProcurementReportsPage> {
  bool _isLoading = true;
  bool _isBackendData = false;

  double _toplamGider = 0;
  int _toplamSiparis = 0;
  int _bekleyenSiparis = 0;
  
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

    if (summary != null && spending != null) {
      setState(() {
        _isBackendData = true;
        
        // Backend'de onaylanmış olanlar sipariş sayılır
        _toplamSiparis = summary['approved'] ?? 0;
        
        // Bekleyen siparişler (onay bekleyen talepler)
        _bekleyenSiparis = summary['pending'] ?? 0;
        
        // Toplam Gider
        double spendSum = 0;
        for (var item in spending) {
          final amt = item['totalAmount'];
          spendSum += amt is num ? amt.toDouble() : double.tryParse(amt.toString()) ?? 0.0;
        }
        _toplamGider = spendSum;

        _isLoading = false;
      });
      return;
    }

    // 2. Fallback: Yerel mock veritabanı hesaplaması
    final requests = RequestService().getRequests();
    setState(() {
      _isBackendData = false;
      _toplamSiparis = requests.where((r) => r.status == RequestStatus.ordered || r.status == RequestStatus.completed).length;
      _bekleyenSiparis = requests.where((r) => r.status == RequestStatus.approved).length; // Approved waiting to be ordered
      
      _toplamGider = requests.where((r) => r.status == RequestStatus.ordered || r.status == RequestStatus.completed).fold(0.0, (sum, r) {
        final selectedOffer = r.offers.firstWhere((o) => o.isSelected, orElse: () => OfferModel(id: '', requestId: '', supplierName: '', price: 0, currency: '', description: ''));
        if (selectedOffer.currency == "TL") {
          return sum + (selectedOffer.price * r.quantity);
        }
        return sum;
      });

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
        Navigator.pushReplacementNamed(context, '/procurement_home');
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
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),

                        /// Sayfa Başlığı
                        Text(
                          "Finansal Özet",
                          style: AppStyles.heading2.copyWith(
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Özet Kartlar
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                "Verilen Sipariş",
                                "$_toplamSiparis Adet",
                                Icons.shopping_cart_checkout,
                                AppColors.success,
                                isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                "Toplam Gider",
                                "₺${_toplamGider.toStringAsFixed(0)}",
                                Icons.trending_down,
                                AppColors.error,
                                isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryCard(
                          _isBackendData ? "Bekleyen Talepler" : "Bekleyen Sipariş (Onaylanmış)",
                          "$_bekleyenSiparis Adet",
                          Icons.pending_actions_outlined,
                          AppColors.warning,
                          isDark,
                          isFullWidth: true,
                        ),

                        const SizedBox(height: 32),

                        /// Grafik Bölümü
                        Text(
                          "Harcama Dağılımı",
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
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    borderData: FlBorderData(show: false),
                                    centerSpaceRadius: 40,
                                    sectionsSpace: 4,
                                    sections: [
                                      PieChartSectionData(
                                        value: _toplamGider > 0 ? _toplamGider : 1,
                                        title: "Gider",
                                        radius: 60,
                                        color: AppColors.error,
                                        titleStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLegendDot(AppColors.error, "Toplam Harcama", isDark),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: const ProcurementNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.caption.copyWith(
                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.heading2.copyWith(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppStyles.bodyText.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
