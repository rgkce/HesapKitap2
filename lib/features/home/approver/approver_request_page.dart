import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/approver_navbar.dart';

class ApproverRequestsPage extends StatefulWidget {
  const ApproverRequestsPage({super.key});

  @override
  State<ApproverRequestsPage> createState() => _ApproverRequestsPageState();
}

class _ApproverRequestsPageState extends State<ApproverRequestsPage> {
  final List<Map<String, String>> requests = [
    {"id": "REQ-001", "desc": "Satın alma talebi - Laptop"},
    {"id": "REQ-002", "desc": "Ofis malzemesi - Kalem"},
    {"id": "REQ-003", "desc": "Yazılım lisansı"},
  ];

  void _approveRequest(String id) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$id talebi onaylandı ✅")));
  }

  void _rejectRequest(String id) {
    final reasonController = TextEditingController();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Talebi Reddet",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.warning : AppColors.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$id numaralı talep için reddetme sebebi giriniz:",
                style: AppStyles.heading3.copyWith(
                  color: isDark ? AppColors.grey200 : AppColors.grey800,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                style: AppStyles.heading3.copyWith(
                  color: isDark ? AppColors.grey200 : AppColors.grey800,
                ),
                decoration: InputDecoration(
                  hintText: "Sebep yazınız...",
                  hintStyle: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.grey800 : AppColors.grey200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.buttonText.copyWith(
                  color:
                      isDark
                          ? AppColors.warning.withOpacity(0.9)
                          : AppColors.warning,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sebep giriniz ❗")),
                  );
                  return;
                }
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$id reddedildi ❌ Sebep: $reason")),
                );
              },
              child: Text(
                "Reddet",
                style: AppStyles.buttonText.copyWith(
                  color:
                      isDark
                          ? AppColors.grey100.withOpacity(0.9)
                          : AppColors.grey100,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDark
                      ? [AppColors.grey800, AppColors.primary.withOpacity(0.8)]
                      : [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.accent.withOpacity(0.8),
                      ],
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
                  Text(
                    "Onay Bekleyen Talepler",
                    style: AppStyles.heading1.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(
                              req["desc"]!,
                              style: AppStyles.bodyText.copyWith(
                                color:
                                    isDark
                                        ? AppColors.grey100
                                        : AppColors.grey800,
                              ),
                            ),
                            subtitle: Text(
                              req["id"]!,
                              style: AppStyles.bodyText.copyWith(
                                color:
                                    isDark
                                        ? AppColors.grey100
                                        : AppColors.grey800,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                  ),
                                  onPressed: () => _approveRequest(req["id"]!),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => _rejectRequest(req["id"]!),
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
        ),
        bottomNavigationBar: const ApproverNavBar(currentIndex: 1),
      ),
    );
  }
}
