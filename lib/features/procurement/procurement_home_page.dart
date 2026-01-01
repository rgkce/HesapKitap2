import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/procurement_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:intl/intl.dart';

class ProcurementHomePage extends StatefulWidget {
  const ProcurementHomePage({super.key});

  @override
  State<ProcurementHomePage> createState() => _ProcurementHomePageState();
}

class _ProcurementHomePageState extends State<ProcurementHomePage> {
  List<RequestModel> _requests = [];
  List<Map<String, dynamic>> _recentOffersData = [];
  int _totalRequests = 0;
  int _pendingAction = 0;
  int _totalOffers = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _requests = RequestService().getRequests();
      _totalRequests = _requests.length;

      // Calculate pending (requests with no offers or just pending)
      _pendingAction =
          _requests.where((r) => r.status == RequestStatus.pending).length;

      // Collect all offers with their associated request titles
      final List<Map<String, dynamic>> allOffersWithTitles = [];
      for (var req in _requests) {
        final String title = req.title;
        for (var offer in req.offers) {
          allOffersWithTitles.add({'offer': offer, 'requestTitle': title});
        }
      }

      _totalOffers = allOffersWithTitles.length;

      // Sort by offer ID (timestamp) descending for "Recent"
      allOffersWithTitles.sort((a, b) {
        final idA = (a['offer'] as OfferModel).id;
        final idB = (b['offer'] as OfferModel).id;
        return idB.compareTo(idA);
      });
      _recentOffersData = allOffersWithTitles.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final summaryStats = [
      {
        "label": "Talepler",
        "value": "$_totalRequests",
        "color": AppColors.primary,
        "icon": Icons.assignment_outlined,
      },
      {
        "label": "Bekleyen",
        "value": "$_pendingAction",
        "color": AppColors.warning,
        "icon": Icons.pending_actions_outlined,
      },
      {
        "label": "Tekliflerim",
        "value": "$_totalOffers",
        "color": AppColors.success,
        "icon": Icons.local_offer_outlined,
      },
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text("Satınalma Paneli"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => _loadData(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Karşılama
                  Text(
                    "Merhaba, ${UserService().currentUser?.name.split(' ').first ?? 'Satınalma'} 👋",
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

                  /// Son Tekliflerim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Son Tekliflerim",
                        style: AppStyles.heading2.copyWith(
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Could navigate to a dedicated offers list if existed
                        },
                        child: const Text("Tümü"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_recentOffersData.isEmpty)
                    _buildEmptyState(
                      "Henüz teklif vermediniz.",
                      Icons.local_offer_outlined,
                      isDark,
                    )
                  else
                    Column(
                      children:
                          _recentOffersData
                              .map(
                                (data) => _buildOfferCard(
                                  data['offer'] as OfferModel,
                                  data['requestTitle'] as String,
                                  isDark,
                                ),
                              )
                              .toList(),
                    ),

                  const SizedBox(height: 32),

                  /// Bekleyen Talepler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bekleyen Talepler",
                        style: AppStyles.heading2.copyWith(
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pushReplacementNamed(
                              context,
                              '/procurement_requests',
                            ),
                        child: const Text("Tümü"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_requests
                      .where((r) => r.status == RequestStatus.pending)
                      .isEmpty)
                    _buildEmptyState(
                      "Bekleyen talep yok.",
                      Icons.check_circle_outline_rounded,
                      isDark,
                    )
                  else
                    Column(
                      children:
                          _requests
                              .where((r) => r.status == RequestStatus.pending)
                              .take(3)
                              .map((req) => _buildRequestCard(req, isDark))
                              .toList(),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ProcurementNavBar(currentIndex: 0),
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

  Widget _buildOfferCard(OfferModel offer, String requestTitle, bool isDark) {
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
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.success,
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requestTitle,
              style: AppStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              offer.supplierName,
              style: AppStyles.bodyTextBold.copyWith(
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
        subtitle: Text(
          offer.description,
          style: AppStyles.caption.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          "${offer.price.toStringAsFixed(0)} ${offer.currency}",
          style: AppStyles.bodyTextBold.copyWith(color: AppColors.success),
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestModel req, bool isDark) {
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
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(req.createdAt),
          style: AppStyles.caption.copyWith(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.grey400,
        ),
        onTap: () => Navigator.pushNamed(context, '/procurement_requests'),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: isDark ? AppColors.grey600 : AppColors.grey300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppStyles.bodyText.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
