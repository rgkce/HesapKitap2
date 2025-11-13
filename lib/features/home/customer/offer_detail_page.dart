import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class OfferDetailPage extends StatelessWidget {
  final Map<String, String> offer;

  const OfferDetailPage({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false, // Telefon geri butonunu engelle
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.9), AppColors.accent],
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
                  Row(
                    children: [
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: isDark ? AppColors.grey400 : AppColors.grey200,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/customer_offers',
                          );
                        },
                      ),
                      SizedBox(width: 40),
                      Text(
                        "Teklif Detayı",
                        style: AppStyles.heading1.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// Teklif Bilgileri Kartı
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.grey800.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Firma", offer["company"]!),
                        const SizedBox(height: 12),
                        _buildInfoRow("Teklif No", offer["id"]!),
                        const SizedBox(height: 12),
                        _buildInfoRow("Tarih", offer["date"]!),
                        const SizedBox(height: 12),
                        _buildInfoRow("Miktar", offer["amount"]!),
                        const SizedBox(height: 12),
                        _buildInfoRow("Durum", offer["status"]!),
                        if (offer["status"] == "Reddedildi" &&
                            offer["reason"] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _buildInfoRow(
                              "Reddetme Sebebi",
                              offer["reason"]!,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Açıklama / Notlar
                  Text(
                    "Açıklama / Notlar",
                    style: AppStyles.heading2.copyWith(
                      color: AppColors.textLight,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey800.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      offer["note"] ?? "Detay yok",
                      style: AppStyles.bodyText.copyWith(
                        color: AppColors.textLight.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// İşlem Butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Kabul işlemi
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Kabul Et",
                            style: AppStyles.bodyTextBold.copyWith(
                              color: AppColors.grey100,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showRejectReasonDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Reddet",
                            style: AppStyles.bodyTextBold.copyWith(
                              color: AppColors.grey100,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Bilgi satırı
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "$label:",
            style: AppStyles.bodyTextBold.copyWith(
              color: AppColors.textLight.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: AppStyles.bodyText.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Reddetme sebebi girişi
  void _showRejectReasonDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController(
      text: offer["reason"] ?? "",
    );
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          title: Text(
            "Reddetme Sebebi",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            style: AppStyles.bodyText.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
            decoration: InputDecoration(
              hintText: "Reddetme sebebini girin...",
              hintStyle: AppStyles.bodyText.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.grey400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.bodyTextBold.copyWith(color: AppColors.error),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                offer["status"] = "Reddedildi";
                offer["reason"] = reasonController.text;
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(
                "Kaydet",
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
