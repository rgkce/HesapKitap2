import 'package:hesapkitap/core/models/request_model.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/user_model.dart';

class RequestService {
  static final RequestService _instance = RequestService._internal();

  factory RequestService() {
    return _instance;
  }

  RequestService._internal();

  final List<RequestModel> _requests = [];

  // Mock Data Initialization
  void initMockData() {
    if (_requests.isNotEmpty) return;

    // Add some dummy requests
    _requests.add(
      RequestModel(
        id: "req1",
        title: "Ofis Kırtasiye İhtiyacı",
        description: "A4 kağıt, kalem, zımba vb. aylık ihtiyaç.",
        status: RequestStatus.pending,
        createdBy: "user1", // Assume existing user ID
        companyId: "comp1",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    );
    _requests.add(
      RequestModel(
        id: "req2",
        title: "Laptop Bataryası",
        description: "Dell Latitude 5420 için yedek batarya.",
        status: RequestStatus.offersReceived,
        createdBy: "user1",
        companyId: "comp1",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        offers: [
          OfferModel(
            id: 'off1',
            requestId: 'req2',
            supplierName: 'TechStore',
            price: 1500,
            currency: 'TL',
            description: 'Orijinal Batarya',
          ),
          OfferModel(
            id: 'off2',
            requestId: 'req2',
            supplierName: 'BataryaDünyası',
            price: 1200,
            currency: 'TL',
            description: 'Muadil Batarya',
          ),
        ],
      ),
    );
  }

  List<RequestModel> getRequests() {
    // If empty, verify if we should init (simple check)
    if (_requests.isEmpty) initMockData();

    final user = UserService().currentUser;
    if (user == null) return [];

    // Filter based on user role and company
    if (user.role == UserRole.admin || user.role == UserRole.manager) {
      // Admin and Manager see all requests for their company
      return _requests.where((r) => r.companyId == user.companyId).toList();
    } else if (user.role == UserRole.procurement) {
      // Procurement sees ALL requests for their company to get quotes
      return _requests.where((r) => r.companyId == user.companyId).toList();
    }

    return [];
  }

  Future<bool> createRequest(String title, String description) async {
    final user = UserService().currentUser;
    if (user == null) return false;

    final newRequest = RequestModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      status: RequestStatus.pending,
      createdBy: user.id,
      companyId: user.companyId,
      createdAt: DateTime.now(),
    );

    _requests.add(newRequest);
    return true;
  }

  // Add Offer (for Procurement)
  Future<bool> addOffer(String requestId, OfferModel offer) async {
    int index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      var req = _requests[index];
      // Create a new list of offers
      List<OfferModel> updatedOffers = List.from(req.offers)..add(offer);

      // Update status to offersReceived if it was pending
      RequestStatus newStatus = req.status;
      if (newStatus == RequestStatus.pending) {
        newStatus = RequestStatus.offersReceived;
      }

      _requests[index] = RequestModel(
        id: req.id,
        title: req.title,
        description: req.description,
        status: newStatus,
        createdBy: req.createdBy,
        companyId: req.companyId,
        createdAt: req.createdAt,
        offers: updatedOffers,
      );
      return true;
    }
    return false;
  }

  // Select Offer (for Manager)
  Future<bool> selectOffer(String requestId, String offerId) async {
    int index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      var req = _requests[index];

      // Update offers (set isSelected: true only for the target offerId)
      List<OfferModel> updatedOffers =
          req.offers.map((o) {
            return OfferModel(
              id: o.id,
              requestId: o.requestId,
              supplierName: o.supplierName,
              price: o.price,
              currency: o.currency,
              description: o.description,
              paymentMethod: o.paymentMethod ?? "Peşin",
              paymentTerm: o.paymentTerm ?? 0,
              isSelected: o.id == offerId,
            );
          }).toList();

      _requests[index] = RequestModel(
        id: req.id,
        title: req.title,
        description: req.description,
        status: RequestStatus.approved, // Ensure status is approved
        createdBy: req.createdBy,
        companyId: req.companyId,
        createdAt: req.createdAt,
        offers: updatedOffers,
      );
      return true;
    }
    return false;
  }

  // Mark as Ordered (for Procurement)
  Future<bool> markAsOrdered(String requestId) async {
    int index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      var req = _requests[index];
      _requests[index] = RequestModel(
        id: req.id,
        title: req.title,
        description: req.description,
        status: RequestStatus.ordered,
        createdBy: req.createdBy,
        companyId: req.companyId,
        createdAt: req.createdAt,
        offers: req.offers,
      );
      return true;
    }
    return false;
  }

  // Cancel Approval (for Manager)
  Future<bool> cancelApproval(String requestId) async {
    int index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      var req = _requests[index];

      // Reset all offers to not selected
      List<OfferModel> updatedOffers =
          req.offers.map((o) {
            return OfferModel(
              id: o.id,
              requestId: o.requestId,
              supplierName: o.supplierName,
              price: o.price,
              currency: o.currency,
              description: o.description,
              paymentMethod: o.paymentMethod ?? "Peşin",
              paymentTerm: o.paymentTerm ?? 0,
              isSelected: false,
            );
          }).toList();

      _requests[index] = RequestModel(
        id: req.id,
        title: req.title,
        description: req.description,
        status: RequestStatus.offersReceived, // Back to offersReceived
        createdBy: req.createdBy,
        companyId: req.companyId,
        createdAt: req.createdAt,
        offers: updatedOffers,
      );
      return true;
    }
    return false;
  }

  // Complete Request (for Manager)
  Future<bool> completeRequest(String requestId) async {
    int index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      var req = _requests[index];
      _requests[index] = RequestModel(
        id: req.id,
        title: req.title,
        description: req.description,
        status: RequestStatus.completed,
        createdBy: req.createdBy,
        companyId: req.companyId,
        createdAt: req.createdAt,
        offers: req.offers,
      );
      return true;
    }
    return false;
  }
}
