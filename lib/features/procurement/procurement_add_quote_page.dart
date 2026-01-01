import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/features/navigation/procurement_navbar.dart';

class ProcurementAddQuotePage extends StatefulWidget {
  final RequestModel? request;

  const ProcurementAddQuotePage({super.key, this.request});

  @override
  State<ProcurementAddQuotePage> createState() =>
      _ProcurementAddQuotePageState();
}

class _ProcurementAddQuotePageState extends State<ProcurementAddQuotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  RequestModel? _selectedRequest;
  List<RequestModel> _pendingRequests = [];
  bool _isLoading = false;
  String _currency = "TL";
  String _paymentMethod = "Peşin";
  int _paymentTerm = 0;

  @override
  void initState() {
    super.initState();
    if (widget.request != null) {
      _selectedRequest = widget.request;
    } else {
      _loadPendingRequests();
    }
  }

  void _loadPendingRequests() {
    final requests = RequestService().getRequests();
    setState(() {
      _pendingRequests =
          requests
              .where(
                (r) =>
                    r.status == RequestStatus.pending ||
                    r.status == RequestStatus.offersReceived,
              )
              .toList();
    });
  }

  void _submitQuote() async {
    if (_selectedRequest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen bir talep seçiniz.")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final offer = OfferModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        requestId: _selectedRequest!.id,
        supplierName: _supplierController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        currency: _currency,
        description: _descController.text,
        paymentMethod: _paymentMethod,
        paymentTerm: _paymentTerm,
      );

      final success = await RequestService().addOffer(
        _selectedRequest!.id,
        offer,
      );

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Teklif başarıyla eklendi!")),
          );

          if (widget.request == null) {
            // Started from Navbar, reset form
            _formKey.currentState!.reset();
            _supplierController.clear();
            _priceController.clear();
            _descController.clear();
            setState(() {
              _selectedRequest = null;
              _paymentMethod = "Peşin";
              _paymentTerm = 0;
            });
          } else {
            // Started from List, pop
            Navigator.pop(context);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Teklif eklenirken hata oluştu.")),
          );
        }
      }
    }
  }

  void _showTermPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.grey200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vade Seçiniz (Gün)", style: AppStyles.bodyTextBold),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tamam"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.2,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _paymentTerm = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          "$index Gün",
                          style: AppStyles.bodyText.copyWith(
                            fontSize: 20,
                            fontWeight:
                                _paymentTerm == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            color:
                                _paymentTerm == index
                                    ? AppColors.primary
                                    : AppColors.textDark,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFromList = widget.request != null;

    return WillPopScope(
      onWillPop: () async => isFromList,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Teklif Ekle"),
          leading:
              isFromList
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                  )
                  : null,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Selection / Display
                  if (_selectedRequest != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.description,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Talep Detayı", style: AppStyles.caption),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedRequest!.title,
                                  style: AppStyles.bodyTextBold,
                                ),
                              ],
                            ),
                          ),
                          if (!isFromList)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.error,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedRequest = null;
                                });
                              },
                            ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: DropdownButtonFormField<RequestModel>(
                        decoration: const InputDecoration(
                          labelText: "Talep Seçiniz",
                          prefixIcon: Icon(Icons.assignment),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        items:
                            _pendingRequests.map((req) {
                              return DropdownMenuItem(
                                value: req,
                                child: Text(
                                  req.title.length > 30
                                      ? "${req.title.substring(0, 30)}..."
                                      : req.title,
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedRequest = val;
                          });
                        },
                      ),
                    ),

                  TextFormField(
                    controller: _supplierController,
                    decoration: const InputDecoration(
                      labelText: "Tedarikçi Firma",
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? "Firma adı giriniz" : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Fiyat",
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: AppColors.grey400),
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Fiyat giriniz" : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _currency,
                          items:
                              ["TL", "USD", "EUR"]
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setState(() => _currency = v!),
                          decoration: const InputDecoration(
                            labelText: "Birim",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: AppColors.grey400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: _paymentMethod,
                          items:
                              ["Peşin", "Vadeli", "Kredi Kartı"]
                                  .map(
                                    (m) => DropdownMenuItem(
                                      value: m,
                                      child: Text(m),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) {
                            setState(() {
                              _paymentMethod = v!;
                              if (_paymentMethod == "Peşin") {
                                _paymentTerm = 0;
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Ödeme Şekli",
                            prefixIcon: Icon(Icons.payment),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: AppColors.grey400),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap:
                              _paymentMethod == "Vadeli"
                                  ? _showTermPicker
                                  : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    _paymentMethod == "Vadeli"
                                        ? AppColors.primary.withOpacity(0.5)
                                        : AppColors.grey400,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color:
                                  _paymentMethod != "Vadeli"
                                      ? AppColors.grey100
                                      : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$_paymentTerm Gün",
                                  style: AppStyles.bodyText.copyWith(
                                    color:
                                        _paymentMethod == "Vadeli"
                                            ? AppColors.textDark
                                            : AppColors.grey600,
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.grey600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Açıklama / Ürün Detayı",
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Icons.notes),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: AppColors.grey400),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? "Açıklama giriniz" : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitQuote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Teklifi Kaydet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:
            isFromList ? null : const ProcurementNavBar(currentIndex: 2),
      ),
    );
  }
}
