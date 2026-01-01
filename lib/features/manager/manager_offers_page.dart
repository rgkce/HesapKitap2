import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/manager/request_offers_page.dart';
import 'package:hesapkitap/features/navigation/manager_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:intl/intl.dart';

class ManagerOffersPage extends StatefulWidget {
  const ManagerOffersPage({super.key});

  @override
  State<ManagerOffersPage> createState() => _ManagerOffersPageState();
}

class _ManagerOffersPageState extends State<ManagerOffersPage> {
  List<RequestModel> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      // Fetch only requests that have offers or approved/completed
      // Actually strictly 'offersReceived' for "Selection"
      _requests =
          RequestService()
              .getRequests()
              .where(
                (r) =>
                    r.status == RequestStatus.offersReceived ||
                    r.status == RequestStatus.approved ||
                    r.status == RequestStatus.completed,
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gelen Teklifler"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                _requests.isEmpty
                    ? Center(
                      child: Text(
                        "Henüz teklif gelen bir talep yok.",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                    : ListView.builder(
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        final req = _requests[index];
                        // Offers count
                        final offerCount = req.offers.length;

                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => RequestOffersPage(request: req),
                                ),
                              ).then((_) => _loadData());
                            },
                            leading: CircleAvatar(
                              backgroundColor: AppColors.accent.withOpacity(
                                0.1,
                              ),
                              child: const Icon(
                                Icons.list_alt,
                                color: AppColors.accent,
                              ),
                            ),
                            title: Text(
                              req.title,
                              style: AppStyles.bodyTextBold,
                            ),
                            subtitle: Text(
                              "Teklif Sayısı: $offerCount • ${DateFormat('dd/MM/yyyy').format(req.createdAt)}",
                              style: AppStyles.caption,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ),
        bottomNavigationBar: const ManagerNavBar(currentIndex: 1),
      ),
    );
  }
}
