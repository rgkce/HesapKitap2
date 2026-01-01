import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/procurement_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/features/procurement/procurement_add_quote_page.dart';
import 'package:intl/intl.dart';

class ProcurementRequestsPage extends StatefulWidget {
  const ProcurementRequestsPage({super.key});

  @override
  State<ProcurementRequestsPage> createState() =>
      _ProcurementRequestsPageState();
}

class _ProcurementRequestsPageState extends State<ProcurementRequestsPage> {
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gelen Talepler"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      _requests.isEmpty
                          ? Center(
                            child: Text(
                              "Talep bulunamadı.",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.grey600),
                            ),
                          )
                          : ListView.builder(
                            itemCount: _requests.length,
                            itemBuilder: (context, index) {
                              final req = _requests[index];
                              final offerCount = req.offers.length;

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              req.title,
                                              style: AppStyles.bodyTextBold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.info.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: AppColors.info
                                                    .withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              "$offerCount Teklif",
                                              style: const TextStyle(
                                                color: AppColors.info,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        req.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.bodyText.copyWith(
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(req.createdAt),
                                            style: AppStyles.caption,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          ProcurementAddQuotePage(
                                                            request: req,
                                                          ),
                                                ),
                                              ).then((_) => _loadData());
                                            },
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              size: 18,
                                            ),
                                            label: const Text("Teklif Ver"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const ProcurementNavBar(currentIndex: 1),
      ),
    );
  }
}
