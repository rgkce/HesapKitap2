import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/supplier_navbar.dart';

class SupplierStockPage extends StatefulWidget {
  const SupplierStockPage({super.key});

  @override
  State<SupplierStockPage> createState() => _SupplierStockPageState();
}

class _SupplierStockPageState extends State<SupplierStockPage> {
  List<Map<String, dynamic>> stockItems = [
    {"name": "Ürün A", "stock": 120, "min": 50},
    {"name": "Ürün B", "stock": 15, "min": 30},
    {"name": "Ürün C", "stock": 75, "min": 40},
    {"name": "Ürün D", "stock": 5, "min": 20},
  ];

  void _showStockDialog({Map<String, dynamic>? item, int? index}) {
    final nameController = TextEditingController(text: item?["name"] ?? "");
    final stockController = TextEditingController(
      text: item?["stock"]?.toString() ?? "",
    );
    final minController = TextEditingController(
      text: item?["min"]?.toString() ?? "",
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
            item == null ? "Yeni Ürün Ekle" : "Stok Güncelle",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Ürün Adı"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Mevcut Stok"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Minimum Stok"),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              onPressed: () {
                final newItem = {
                  "name": nameController.text,
                  "stock": int.tryParse(stockController.text) ?? 0,
                  "min": int.tryParse(minController.text) ?? 0,
                };

                setState(() {
                  if (item == null) {
                    stockItems.add(newItem);
                  } else if (index != null) {
                    stockItems[index] = newItem;
                  }
                });

                Navigator.pop(context);
              },
              child: Text(
                item == null ? "Ekle" : "Kaydet",
                style: AppStyles.bodyText.copyWith(color: AppColors.grey100),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          title: Text(
            "Ürünü Sil",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: Text(
            "'${stockItems[index]["name"]}' ürününü silmek istediğinize emin misiniz?",
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
                  color:
                      isDark
                          ? AppColors.warning.withOpacity(0.9)
                          : AppColors.warning,
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
                setState(() {
                  stockItems.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text(
                "Sil",
                style: AppStyles.buttonText.copyWith(color: AppColors.grey100),
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
                  child: Text(
                    "Stok Yönetimi",
                    style: AppStyles.heading1.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: stockItems.length,
                    itemBuilder: (context, index) {
                      final item = stockItems[index];
                      final bool lowStock = item["stock"] < item["min"];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: Icon(
                            lowStock
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle,
                            color:
                                lowStock ? AppColors.error : AppColors.success,
                            size: 28,
                          ),
                          title: Text(
                            item["name"],
                            style: AppStyles.bodyTextBold.copyWith(
                              fontSize: 18,
                              color:
                                  isDark
                                      ? AppColors.grey200
                                      : AppColors.grey800,
                            ),
                          ),
                          subtitle: Text(
                            "Mevcut: ${item["stock"]} • Minimum: ${item["min"]}",
                            style: AppStyles.bodyText.copyWith(
                              color:
                                  isDark
                                      ? AppColors.grey200
                                      : AppColors.grey600,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.accent,
                                ),
                                onPressed:
                                    () => _showStockDialog(
                                      item: item,
                                      index: index,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.error,
                                ),
                                onPressed: () => _deleteItem(index),
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
        bottomNavigationBar: const SupplierNavBar(currentIndex: 3),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.info,
          child: const Icon(Icons.add),
          onPressed: () => _showStockDialog(),
        ),
      ),
    );
  }
}
