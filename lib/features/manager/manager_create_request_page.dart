import 'package:flutter/material.dart';

import 'package:hesapkitap/features/navigation/manager_navbar.dart';
import 'package:hesapkitap/core/services/request_service.dart';

class ManagerCreateRequestPage extends StatefulWidget {
  const ManagerCreateRequestPage({super.key});

  @override
  State<ManagerCreateRequestPage> createState() =>
      _ManagerCreateRequestPageState();
}

class _ManagerCreateRequestPageState extends State<ManagerCreateRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _priority = "Normal";
  bool _isLoading = false;

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final title =
          "${_productController.text} - ${_quantityController.text} Adet";
      final description = "Öncelik: $_priority\nNot: ${_noteController.text}";

      // Simulate network
      await Future.delayed(const Duration(seconds: 1));

      final success = await RequestService().createRequest(title, description);

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Talep başarıyla oluşturuldu!")),
          );
          // Navigate to dashboard to see the request
          Navigator.pushReplacementNamed(context, '/manager_home');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Talep oluşturulurken hata oluştu.")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Talep Oluştur"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productController,
                      decoration: const InputDecoration(labelText: "Ürün Adı"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ürün adı giriniz";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Miktar"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Miktar giriniz";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _priority,
                      items:
                          ["Normal", "Acil"]
                              .map(
                                (p) =>
                                    DropdownMenuItem(value: p, child: Text(p)),
                              )
                              .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _priority = v);
                      },
                      decoration: const InputDecoration(labelText: "Öncelik"),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Notlar (Opsiyonel)",
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitRequest,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Talep Oluştur"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const ManagerNavBar(currentIndex: 2),
      ),
    );
  }
}
