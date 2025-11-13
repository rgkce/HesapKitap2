import 'package:flutter/material.dart';
import 'package:hesapkitap/features/navigation/supplier_navbar.dart';
import 'package:intl/intl.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';

class SupplierPaymentsPage extends StatefulWidget {
  const SupplierPaymentsPage({Key? key}) : super(key: key);

  @override
  State<SupplierPaymentsPage> createState() => _SupplierPaymentsPageState();
}

class _SupplierPaymentsPageState extends State<SupplierPaymentsPage> {
  final List<Map<String, dynamic>> payments = [
    {"date": DateTime(2025, 9, 1), "amount": 12000, "status": "Ödendi"},
    {"date": DateTime(2025, 9, 5), "amount": 8000, "status": "Bekliyor"},
    {"date": DateTime(2025, 9, 8), "amount": 15000, "status": "Ödendi"},
  ];

  String? selectedFilter;

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
                /// Başlık
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Ödemeler",
                    style: AppStyles.heading1.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// Filtre Dropdown
                DropdownButton<String>(
                  dropdownColor: isDark ? AppColors.grey800 : AppColors.grey100,
                  value: selectedFilter,
                  hint: const Text("Duruma göre filtrele"),
                  items:
                      ["Tümü", "Ödendi", "Bekliyor"]
                          .map(
                            (f) => DropdownMenuItem(value: f, child: Text(f)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() => selectedFilter = val);
                  },
                ),
                const SizedBox(height: 12),

                /// Alt Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // PDF indir
                      },
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: AppColors.grey100,
                        size: 25,
                      ),
                      label: Text(
                        "PDF İndir",
                        style: AppStyles.buttonText.copyWith(
                          color: AppColors.grey100,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.info,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Excel indir
                      },
                      icon: const Icon(
                        Icons.table_chart,
                        color: AppColors.grey100,
                        size: 25,
                      ),
                      label: Text(
                        "Excel İndir",
                        style: AppStyles.buttonText.copyWith(
                          color: AppColors.grey100,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.info,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// Liste
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        if (selectedFilter != null &&
                            selectedFilter != "Tümü" &&
                            payment["status"] != selectedFilter) {
                          return const SizedBox();
                        }
                        return Card(
                          color: isDark ? AppColors.grey800 : AppColors.grey100,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: Icon(
                              payment["status"] == "Ödendi"
                                  ? Icons.check_circle
                                  : Icons.pending,
                              color:
                                  payment["status"] == "Ödendi"
                                      ? AppColors.success
                                      : AppColors.warning,
                            ),
                            title: Text(
                              "₺${payment["amount"]}",
                              style: AppStyles.heading2.copyWith(
                                color:
                                    isDark
                                        ? AppColors.grey100
                                        : AppColors.grey800,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat("dd MMM yyyy").format(payment["date"]),
                              style: AppStyles.bodyText.copyWith(
                                color:
                                    isDark
                                        ? AppColors.grey100
                                        : AppColors.grey600,
                              ),
                            ),
                            trailing: Text(
                              payment["status"],
                              style: AppStyles.bodyText.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    payment["status"] == "Ödendi"
                                        ? AppColors.success
                                        : AppColors.warning,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Ödeme ekleme butonu
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddPaymentDialog(context, isDark);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.grey100,
                    size: 25,
                  ),
                  label: Text(
                    "Ödeme Ekle",
                    style: AppStyles.buttonText.copyWith(
                      color: AppColors.grey100,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const SupplierNavBar(currentIndex: 2),
      ),
    );
  }

  /// Ödeme ekleme popup
  void _showAddPaymentDialog(BuildContext context, bool isDark) {
    final TextEditingController amountController = TextEditingController();
    String status = "Bekliyor";

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? AppColors.grey800 : Colors.white,
            title: Text(
              "Yeni Ödeme Ekle",
              style: AppStyles.heading2.copyWith(
                color: isDark ? AppColors.grey200 : AppColors.grey800,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: "Tutar (₺)"),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: status,
                  items:
                      ["Ödendi", "Bekliyor"]
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      status = val!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  "İptal",
                  style: AppStyles.buttonText.copyWith(
                    color:
                        isDark
                            ? AppColors.warning.withOpacity(0.9)
                            : AppColors.warning,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark
                          ? AppColors.success.withOpacity(0.9)
                          : AppColors.success,
                ),
                child: Text(
                  "Kaydet",
                  style: AppStyles.buttonText.copyWith(
                    color: AppColors.grey100,
                  ),
                ),
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    setState(() {
                      payments.add({
                        "date": DateTime.now(),
                        "amount": int.parse(amountController.text),
                        "status": status,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
    );
  }
}
