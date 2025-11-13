import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/supplier_navbar.dart';

class SupplierRequestsPage extends StatelessWidget {
  const SupplierRequestsPage({super.key});

  // Örnek talep listesi
  final List<Map<String, String>> requests = const [
    {"title": "Ürün A Talebi", "details": "50 adet - Acil"},
    {"title": "Ürün B Talebi", "details": "20 adet"},
    {"title": "Ürün C Talebi", "details": "100 adet - Standart"},
  ];

  void _showApprovalDialog(BuildContext context, String requestTitle) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          title: Text(
            "Talep Onayı",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: Text(
            "'$requestTitle' talebini onaylamak istiyor musunuz?",
            style: AppStyles.heading3.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.buttonText.copyWith(
                  fontSize: 18,
                  color:
                      isDark
                          ? AppColors.warning.withOpacity(0.9)
                          : AppColors.warning,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showRejectionDialog(context, requestTitle);
              },
              child: Text(
                "Reddet",
                style: AppStyles.buttonText.copyWith(
                  fontSize: 18,
                  color: AppColors.error,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark
                        ? AppColors.success.withOpacity(0.9)
                        : AppColors.success,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ '$requestTitle' onaylandı")),
                );
              },
              child: Text(
                "Onayla",
                style: AppStyles.buttonText.copyWith(
                  fontSize: 18,
                  color: AppColors.grey100,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectionDialog(BuildContext context, String requestTitle) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          title: Text(
            "Red Sebebi",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Reddetme sebebini giriniz...",
              hintStyle: TextStyle(
                color: isDark ? AppColors.grey400 : AppColors.grey600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.buttonText.copyWith(
                  fontSize: 18,
                  color: AppColors.warning,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "❌ '$requestTitle' reddedildi. Sebep: ${reasonController.text}",
                    ),
                  ),
                );
              },
              child: Text(
                "Gönder",
                style: AppStyles.buttonText.copyWith(
                  fontSize: 18,
                  color: AppColors.grey100,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Tedarikçi Talepleri",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              req["title"]!,
                              style: AppStyles.bodyTextBold.copyWith(
                                fontSize: 18,
                                color:
                                    isDark
                                        ? AppColors.grey200
                                        : AppColors.grey800,
                              ),
                            ),
                            subtitle: Text(
                              req["details"]!,
                              style: AppStyles.bodyText.copyWith(
                                color:
                                    isDark
                                        ? AppColors.grey200
                                        : AppColors.grey800,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap:
                                () => _showApprovalDialog(
                                  context,
                                  req["title"] ?? "",
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SupplierNavBar(currentIndex: 1),
      ),
    );
  }
}
