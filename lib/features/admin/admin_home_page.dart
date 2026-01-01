import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<RequestModel> _requests = [];
  int _pendingRequests = 0;
  int _approvedRequests = 0;
  double _totalAmount = 0; // Mock calculation
  int _completedRequests = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final requests = RequestService().getRequests();
    setState(() {
      _requests = requests;
      _pendingRequests =
          requests
              .where(
                (r) =>
                    r.status == RequestStatus.pending ||
                    r.status == RequestStatus.offersReceived,
              )
              .length;
      _approvedRequests =
          requests.where((r) => r.status == RequestStatus.approved).length;
      _completedRequests =
          requests.where((r) => r.status == RequestStatus.completed).length;

      // Mock calc for total amount if we had it directly on request or sum of selected offers
      _totalAmount = requests
          .where(
            (r) =>
                r.status == RequestStatus.approved ||
                r.status == RequestStatus.completed,
          )
          .fold(0, (sum, r) {
            final selectedOffer = r.offers.firstWhere(
              (o) => o.isSelected,
              orElse:
                  () => OfferModel(
                    id: '',
                    requestId: '',
                    supplierName: '',
                    price: 0,
                    currency: '',
                    description: '',
                  ),
            );
            if (selectedOffer.currency == "TL") {
              return sum + selectedOffer.price;
            }
            return sum;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Paneli"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Kartları
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    _buildKpiCard(
                      icon: Icons.pending_actions,
                      label: "Bekleyen",
                      value: "$_pendingRequests",
                      color: AppColors.warning,
                    ),
                    _buildKpiCard(
                      icon: Icons.check_circle,
                      label: "Onaylanan",
                      value: "$_approvedRequests",
                      color: AppColors.success,
                    ),
                    _buildKpiCard(
                      icon: Icons.attach_money,
                      label: "Toplam Tutar",
                      value: "₺${_totalAmount.toStringAsFixed(0)}",
                      color: AppColors.info,
                    ),
                    _buildKpiCard(
                      icon: Icons.done_all,
                      label: "Tamamlanan",
                      value: "$_completedRequests",
                      color: AppColors.secondary,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Bekleyen Talepler Listesi
                Text(
                  "Son Talepler",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 10),
                _requests.isEmpty
                    ? Center(
                      child: Text(
                        "Talep bulunamadı",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _requests.take(5).length,
                      itemBuilder: (context, index) {
                        final req = _requests[index];
                        return _buildRequestCard(req);
                      },
                    ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width:
          (MediaQuery.of(context).size.width - 55) /
          2, // 2 column grid responsive
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.surfaceDark.withOpacity(0.7)
                : AppColors.surfaceLight.withOpacity(0.7),

        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppStyles.heading2.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppStyles.bodyText.copyWith(
              color: AppColors.grey600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(RequestModel req) {
    Color statusColor;
    Color statusBgColor;

    switch (req.status) {
      case RequestStatus.pending:
        statusColor = AppColors.warning;
        break;
      case RequestStatus.offersReceived:
        statusColor = AppColors.info;
        break;
      case RequestStatus.approved:
        statusColor = AppColors.success;
        break;
      case RequestStatus.completed:
        statusColor = AppColors.primary;
        break;
      case RequestStatus.rejected:
        statusColor = AppColors.error;
        break;
    }
    statusBgColor = statusColor.withOpacity(0.1);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req.title, style: AppStyles.bodyTextBold),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat("dd/MM/yyyy").format(req.createdAt),
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.grey600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                req.status.label.toUpperCase(),
                style: AppStyles.bodyTextBold.copyWith(
                  color: statusColor,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
