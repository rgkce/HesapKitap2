import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/approver_navbar.dart';

class ApproverSuppliersPage extends StatefulWidget {
  const ApproverSuppliersPage({super.key});

  @override
  State<ApproverSuppliersPage> createState() => _ApproverSuppliersPageState();
}

class _ApproverSuppliersPageState extends State<ApproverSuppliersPage> {
  final List<Map<String, String>> _suppliers = [
    {
      "name": "Demirler Ltd.",
      "email": "info@demirler.com",
      "phone": "+90 555 123 45 67",
      "address": "İstanbul, Türkiye",
    },
    {
      "name": "ABC Elektronik",
      "email": "abc@elektronik.com",
      "phone": "+90 532 987 65 43",
      "address": "Ankara, Türkiye",
    },
  ];

  void _addOrEditSupplier({Map<String, String>? supplier, int? index}) {
    final nameController = TextEditingController(text: supplier?["name"] ?? "");
    final emailController = TextEditingController(
      text: supplier?["email"] ?? "",
    );
    final phoneController = TextEditingController(
      text: supplier?["phone"] ?? "",
    );
    final addressController = TextEditingController(
      text: supplier?["address"] ?? "",
    );

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
            supplier == null ? "Yeni Tedarikçi Ekle" : "Tedarikçiyi Düzenle",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Tedarikçi Adı",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 18,
                    ),
                  ),
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 18,
                    ),
                  ),
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Telefon",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 18,
                    ),
                  ),
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: "Adres",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 18,
                    ),
                  ),
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                ),
              ],
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
                final newSupplier = {
                  "name": nameController.text,
                  "email": emailController.text,
                  "phone": phoneController.text,
                  "address": addressController.text,
                };

                setState(() {
                  if (supplier == null) {
                    _suppliers.add(newSupplier);
                  } else if (index != null) {
                    _suppliers[index] = newSupplier;
                  }
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              child: Text(
                supplier == null ? "Ekle" : "Kaydet",
                style: AppStyles.bodyText.copyWith(color: AppColors.grey100),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteSupplier(int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.grey200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Tedarikçiyi Sil",
            style: AppStyles.heading2.copyWith(color: AppColors.error),
          ),
          content: Text(
            "${_suppliers[index]["name"]} adlı tedarikçiyi silmek istediğinize emin misiniz?",
            style: AppStyles.bodyTextBold.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.grey200,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _suppliers.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(
                "Sil",
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
                children: [
                  Center(
                    child: Text(
                      "Tedarikçi Yönetimi",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = _suppliers[index];
                        return _buildSupplierCard(supplier, index);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _addOrEditSupplier(),
                    icon: const Icon(
                      Icons.add_business,
                      color: AppColors.grey100,
                    ),
                    label: Text(
                      "Yeni Tedarikçi Ekle",
                      style: AppStyles.buttonText.copyWith(
                        color: AppColors.grey100,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ApproverNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildSupplierCard(Map<String, String> supplier, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            supplier["name"]!,
            style: AppStyles.bodyTextBold.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 5),
          Text(
            supplier["email"]!,
            style: AppStyles.bodyText.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 5),
          Text(
            "Telefon: ${supplier["phone"]}",
            style: AppStyles.bodyText.copyWith(color: AppColors.grey200),
          ),
          const SizedBox(height: 5),
          Text(
            "Adres: ${supplier["address"]}",
            style: AppStyles.bodyText.copyWith(color: AppColors.grey200),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed:
                    () => _addOrEditSupplier(supplier: supplier, index: index),
                icon: const Icon(Icons.edit, color: AppColors.info),
              ),
              IconButton(
                onPressed: () => _deleteSupplier(index),
                icon: const Icon(Icons.delete, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
