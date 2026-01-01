enum RequestStatus {
  pending, // Bekliyor (No offers yet)
  offersReceived, // Teklif Geldi
  approved, // Onaylandı (Offer selected by Manager)
  ordered, // Sipariş Oluşturuldu (By Procurement)
  rejected, // Reddedildi (By Manager)
  completed, // Tamamlandı (Process finished)
}

extension RequestStatusExtension on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return "Bekliyor";
      case RequestStatus.offersReceived:
        return "Teklif Geldi";
      case RequestStatus.approved:
        return "Onaylandı";
      case RequestStatus.ordered:
        return "Sipariş Oluşturuldu";
      case RequestStatus.rejected:
        return "Reddedildi";
      case RequestStatus.completed:
        return "Tamamlandı";
    }
  }
}

class OfferModel {
  final String id;
  final String requestId;
  final String supplierName;
  final double price;
  final String currency;
  final String description;
  final String? paymentMethod;
  final int? paymentTerm;
  final bool isSelected;

  OfferModel({
    required this.id,
    required this.requestId,
    required this.supplierName,
    required this.price,
    required this.currency,
    required this.description,
    this.paymentMethod = "Peşin",
    this.paymentTerm = 0,
    this.isSelected = false,
  });
}

class RequestModel {
  final String id;
  final String title;
  final String description;
  final RequestStatus status;
  final String createdBy;
  final String companyId;
  final DateTime createdAt;
  final List<OfferModel> offers;

  RequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.companyId,
    required this.createdAt,
    this.offers = const [],
  });
}
