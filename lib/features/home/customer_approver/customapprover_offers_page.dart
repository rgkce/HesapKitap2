import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/home/customer/offer_detail_page.dart';
import 'package:hesapkitap/features/navigation/customerapprover_navbar.dart';

class CustomApproverOffersPage extends StatefulWidget {
  const CustomApproverOffersPage({super.key});

  @override
  State<CustomApproverOffersPage> createState() =>
      _CustomApproverOffersPageState();
}

class _CustomApproverOffersPageState extends State<CustomApproverOffersPage> {
  String selectedPeriod = "Son 7 gün";
  String selectedStatus = "Tümü";

  final List<Map<String, String>> offers = [
    {
      "id": "T001",
      "company": "ABC Ltd.",
      "amount": "25,000 ₺",
      "date": "01.09.2025",
      "status": "Kabul",
    },
    {
      "id": "T002",
      "company": "XYZ A.Ş.",
      "amount": "12,500 ₺",
      "date": "05.09.2025",
      "status": "Bekliyor",
    },
    {
      "id": "T003",
      "company": "Delta Corp.",
      "amount": "8,000 ₺",
      "date": "07.09.2025",
      "status": "Reddedildi",
    },
  ];

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
                      : [AppColors.primary.withOpacity(0.8), AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Başlık
                  Center(
                    child: Text(
                      "Teklifler",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Filtreler
                  Row(
                    children: [
                      _buildDropdown(
                        value: selectedPeriod,
                        items: ["Son 7 gün", "Son 1 ay", "Tüm Teklifler"],
                        onChanged: (v) => setState(() => selectedPeriod = v!),
                      ),
                      const SizedBox(width: 12),
                      _buildDropdown(
                        value: selectedStatus,
                        items: ["Tümü", "Kabul", "Reddedildi", "Bekliyor"],
                        onChanged: (v) => setState(() => selectedStatus = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Özet Kartlar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryCard("Kabul", "15", [
                        AppColors.success,
                        AppColors.info,
                      ]),
                      _buildSummaryCard("Reddedildi", "6", [
                        AppColors.error,
                        AppColors.warning,
                      ]),
                      _buildSummaryCard("Bekleyen", "9", [
                        AppColors.warning,
                        AppColors.secondary,
                      ]),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Teklif Listesi
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.grey800.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListView.separated(
                        itemCount: offers.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              color: AppColors.grey200.withOpacity(0.2),
                            ),
                        itemBuilder: (context, index) {
                          final offer = offers[index];

                          // Status için renk seçimi
                          Color statusColor =
                              offer["status"] == "Kabul"
                                  ? AppColors.success
                                  : offer["status"] == "Reddedildi"
                                  ? AppColors.error
                                  : AppColors.warning;

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey600.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.accent.withOpacity(
                                    0.2,
                                  ),
                                  child: const Icon(
                                    Icons.description,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${offer["company"]} - ${offer["amount"]}",
                                        style: AppStyles.bodyTextBold.copyWith(
                                          color: AppColors.textLight,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "No: ${offer["id"]} • ${offer["date"]}",
                                        style: AppStyles.bodyText.copyWith(
                                          color: AppColors.textLight
                                              .withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    offer["status"]!,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Aksiyon butonları
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  color: AppColors.info,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                OfferDetailPage(offer: offer),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  color: AppColors.textLight.withOpacity(0.8),
                                  onPressed: () {
                                    // daha fazla aksiyon (popup menu olabilir)
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Teklif Durum Grafiği
                  SizedBox(
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: 15,
                                title: "",
                                radius: 50,
                                color: AppColors.success.withOpacity(0.9),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.success,
                                    AppColors.success.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              PieChartSectionData(
                                value: 6,
                                title: "",
                                radius: 50,
                                color: AppColors.error.withOpacity(0.9),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.error,
                                    AppColors.error.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              PieChartSectionData(
                                value: 9,
                                title: "",
                                radius: 50,
                                color: AppColors.warning.withOpacity(0.9),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.warning,
                                    AppColors.warning.withOpacity(0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 50,
                            sectionsSpace: 2,
                          ),
                        ),
                        // Ortadaki toplam bilgi
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Toplam",
                              style: AppStyles.bodyText.copyWith(
                                color: AppColors.textLight.withOpacity(0.7),
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "30",
                              style: AppStyles.heading2.copyWith(
                                color: AppColors.textLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Açıklama (Legend)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(AppColors.success, "Kabul (15)"),
                      _buildLegendItem(AppColors.error, "Reddedildi (6)"),
                      _buildLegendItem(AppColors.warning, "Bekleyen (9)"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomApproverNavBar(currentIndex: 1),
      ),
    );
  }

  /// 📌 Özet Kart
  Widget _buildSummaryCard(
    String title,
    String value,
    List<Color> gradientColors,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppStyles.bodyTextBold.copyWith(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.heading2.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Dropdown
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      dropdownColor: AppColors.grey800,
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}

// Pie Chart Yardımcı fonksiyon
Widget _buildLegendItem(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: AppStyles.bodyText.copyWith(
          color: AppColors.textLight.withOpacity(0.8),
          fontSize: 15,
        ),
      ),
    ],
  );
}
