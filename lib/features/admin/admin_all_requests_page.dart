import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:intl/intl.dart';
import 'package:hesapkitap/features/manager/request_offers_page.dart'; // Reuse for details

class AdminAllRequestsPage extends StatefulWidget {
  const AdminAllRequestsPage({super.key});

  @override
  State<AdminAllRequestsPage> createState() => _AdminAllRequestsPageState();
}

class _AdminAllRequestsPageState extends State<AdminAllRequestsPage> {
  List<RequestModel> _allRequests = [];
  List<RequestModel> _filteredRequests = [];
  RequestStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _allRequests = RequestService().getRequests();
      _applyFilter();
    });
  }

  void _applyFilter() {
    if (_filterStatus == null) {
      _filteredRequests = List.from(_allRequests);
    } else {
      _filteredRequests =
          _allRequests.where((r) => r.status == _filterStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false, // Nav bar handles navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tüm Talepler"),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<RequestStatus?>(
              icon: Icon(
                Icons.filter_list,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
              onSelected: (value) {
                setState(() {
                  _filterStatus = value;
                  _applyFilter();
                });
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(value: null, child: Text("Tümü")),
                    ...RequestStatus.values.map(
                      (s) => PopupMenuItem(
                        value: s,
                        child: Text(s.label.toUpperCase()),
                      ),
                    ),
                  ],
            ),
          ],
        ),
        body: SafeArea(
          child:
              _filteredRequests.isEmpty
                  ? Center(
                    child: Text(
                      "Talep bulunamadı",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      final req = _filteredRequests[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RequestOffersPage(request: req),
                              ),
                            ).then((_) => _loadRequests());
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      req.title,
                                      style: AppStyles.bodyTextBold,
                                    ),
                                    _buildStatusBadge(req.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  req.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.bodyText.copyWith(
                                    color: AppColors.grey600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Teklif: ${req.offers.length}",
                                      style: AppStyles.caption,
                                    ),
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(req.createdAt),
                                      style: AppStyles.caption,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildStatusBadge(RequestStatus status) {
    Color color;
    switch (status) {
      case RequestStatus.pending:
        color = AppColors.warning;
        break;
      case RequestStatus.offersReceived:
        color = AppColors.info;
        break;
      case RequestStatus.approved:
        color = AppColors.success;
        break;
      case RequestStatus.ordered:
        color = AppColors.accent;
        break;
      case RequestStatus.completed:
        color = AppColors.primary;
        break;
      case RequestStatus.rejected:
        color = AppColors.error;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
