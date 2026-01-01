import 'package:flutter/material.dart';
import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/core/services/request_service.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/user_model.dart';
import 'package:hesapkitap/core/widgets/app_dialog.dart';

class RequestOffersPage extends StatefulWidget {
  final RequestModel request;

  const RequestOffersPage({super.key, required this.request});

  @override
  State<RequestOffersPage> createState() => _RequestOffersPageState();
}

class _RequestOffersPageState extends State<RequestOffersPage> {
  late RequestModel _currentRequest;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentRequest = widget.request;
  }

  void _selectOffer(String offerId) async {
    setState(() => _isLoading = true);

    final success = await RequestService().selectOffer(
      _currentRequest.id,
      offerId,
    );

    setState(() => _isLoading = false);

    if (success) {
      final updatedRequests = RequestService().getRequests();
      final updatedRequest = updatedRequests.firstWhere(
        (r) => r.id == _currentRequest.id,
      );
      setState(() {
        _currentRequest = updatedRequest;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Teklif güncellendi.")));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("İşlem başarısız.")));
      }
    }
  }

  void _completeRequest() async {
    AppDialog.show(
      context,
      title: "Talebi Tamamla",
      message:
          "Bu talebi başarıyla tamamlanmış olarak işaretlemek istiyor musunuz?",
      onConfirm: () async {
        setState(() => _isLoading = true);
        final success = await RequestService().completeRequest(
          _currentRequest.id,
        );
        setState(() => _isLoading = false);

        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Talep tamamlandı.")));
            Navigator.pop(context);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Gelen Teklifler")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequestInfoCard(isDark),
              const SizedBox(height: 20),
              Text("Teklifler", style: AppStyles.heading2),
              const SizedBox(height: 10),
              Expanded(
                child:
                    _currentRequest.offers.isEmpty
                        ? Center(
                          child: Text(
                            "Bu talep için henüz teklif yok.",
                            style: AppStyles.bodyText,
                          ),
                        )
                        : ListView.builder(
                          itemCount: _currentRequest.offers.length,
                          itemBuilder: (context, index) {
                            final offer = _currentRequest.offers[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          offer.supplierName,
                                          style: AppStyles.bodyTextBold
                                              .copyWith(fontSize: 18),
                                        ),
                                        Text(
                                          "${offer.price} ${offer.currency}",
                                          style: AppStyles.bodyTextBold
                                              .copyWith(
                                                fontSize: 18,
                                                color: AppColors.success,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      offer.description,
                                      style: AppStyles.bodyText.copyWith(
                                        color: AppColors.grey600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.payment,
                                          size: 14,
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Ödeme: ${offer.paymentMethod ?? "Peşin"}${offer.paymentMethod == "Vadeli" ? " (${offer.paymentTerm ?? 0} Gün)" : ""}",
                                          style: AppStyles.caption.copyWith(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (_currentRequest.status !=
                                            RequestStatus.completed &&
                                        !offer.isSelected)
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed:
                                              _isLoading
                                                  ? null
                                                  : () =>
                                                      _selectOffer(offer.id),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                          child:
                                              _isLoading
                                                  ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                  : Text(
                                                    _currentRequest.status ==
                                                            RequestStatus
                                                                .approved
                                                        ? "Teklifi Değiştir"
                                                        : "Kabul Et",
                                                  ),
                                        ),
                                      )
                                    else if (offer.isSelected)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppColors.success,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Kabul Edildi",
                                            style: AppStyles.bodyTextBold
                                                .copyWith(
                                                  color: AppColors.success,
                                                ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
              if (UserService().currentUser?.role == UserRole.manager &&
                  _currentRequest.status == RequestStatus.approved)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _completeRequest,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Talebi Tamamla"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestInfoCard(bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Talep Detayı",
              style: AppStyles.bodyTextBold.copyWith(color: AppColors.accent),
            ),
            const Divider(),
            Text(
              _currentRequest.title,
              style: AppStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(_currentRequest.description, style: AppStyles.bodyText),
          ],
        ),
      ),
    );
  }
}
