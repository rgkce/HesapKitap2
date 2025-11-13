import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/customer_navbar.dart';

class CustomerCreateRequestPage extends StatefulWidget {
  const CustomerCreateRequestPage({super.key});

  @override
  State<CustomerCreateRequestPage> createState() =>
      _CustomerCreateRequestPageState();
}

class _CustomerCreateRequestPageState extends State<CustomerCreateRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _priority = "Normal";

  // Oluşturulan talepler listesi
  final List<Map<String, String>> _createdRequests = [];

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        "product": _productController.text,
        "quantity": _quantityController.text,
        "priority": _priority,
        "note": _noteController.text,
      };

      setState(() {
        _createdRequests.add(requestData);

        // Form alanlarını temizle
        _productController.clear();
        _quantityController.clear();
        _noteController.clear();
        _priority = "Normal";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Talep başarıyla oluşturuldu!")),
      );
    }
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
                      : [AppColors.primary.withOpacity(0.8), AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Başlık
                  Center(
                    child: Text(
                      "Satınalma Talepleri",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Oluşturulan Talepler Listesi
                  if (_createdRequests.isNotEmpty) ...[
                    Text(
                      "Oluşturulan Talepler",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.grey100,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: _createdRequests.length,
                        itemBuilder: (context, index) {
                          final req = _createdRequests[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                req["product"]!,
                                style: AppStyles.bodyTextBold,
                              ),
                              subtitle: Text(
                                "Miktar: ${req["quantity"]} • Öncelik: ${req["priority"]}",
                                style: AppStyles.bodyText,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],

                  /// Talep Oluşturma Formu
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Talep Oluştur",
                              style: AppStyles.heading1.copyWith(
                                color: AppColors.grey100,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              controller: _productController,
                              decoration: InputDecoration(
                                labelText: "Ürün Adı",
                                labelStyle: AppStyles.bodyText.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.grey200
                                          : AppColors.textDark,
                                ),
                                filled: true,
                                fillColor:
                                    isDark
                                        ? AppColors.grey800
                                        : AppColors.grey200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ürün adı giriniz";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Miktar",
                                labelStyle: AppStyles.bodyText.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.grey200
                                          : AppColors.textDark,
                                ),
                                filled: true,
                                fillColor:
                                    isDark
                                        ? AppColors.grey800
                                        : AppColors.grey200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Miktar giriniz";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _priority,
                              items:
                                  ["Normal", "Acil"]
                                      .map(
                                        (p) => DropdownMenuItem(
                                          value: p,
                                          child: Text(
                                            p,
                                            style: AppStyles.bodyText,
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _priority = v);
                              },
                              decoration: InputDecoration(
                                labelText: "Öncelik",
                                labelStyle: AppStyles.bodyText.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.grey200
                                          : AppColors.textDark,
                                ),
                                filled: true,
                                fillColor:
                                    isDark
                                        ? AppColors.grey800
                                        : AppColors.grey200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Notlar (Opsiyonel)",
                                labelStyle: AppStyles.bodyText.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.grey200
                                          : AppColors.textDark,
                                ),
                                filled: true,
                                fillColor:
                                    isDark
                                        ? AppColors.grey800
                                        : AppColors.grey200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submitRequest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 40,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                "Talep Oluştur",
                                style: AppStyles.bodyTextBold.copyWith(
                                  color: AppColors.grey100,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomerNavBar(currentIndex: 2),
      ),
    );
  }
}
