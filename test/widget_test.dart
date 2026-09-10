import 'package:flutter_test/flutter_test.dart';
import 'package:hesapkitap/core/models/user_model.dart';
import 'package:hesapkitap/core/models/request_model.dart';

void main() {
  group('UserModel Tests', () {
    test('UserModel is created correctly', () {
      final user = UserModel(
        id: '1',
        name: 'Test User',
        email: 'test@test.com',
        password: '123',
        role: UserRole.admin,
        companyId: 'COMP001',
      );

      expect(user.name, 'Test User');
      expect(user.email, 'test@test.com');
      expect(user.role, UserRole.admin);
      expect(user.companyId, 'COMP001');
    });

    test('UserModel toJson and fromJson work correctly', () {
      final user = UserModel(
        id: '1',
        name: 'Test User',
        email: 'test@test.com',
        password: '123',
        role: UserRole.admin,
        companyId: 'COMP001',
      );

      final json = user.toJson();
      final fromJson = UserModel.fromJson(json);

      expect(fromJson.id, user.id);
      expect(fromJson.name, user.name);
      expect(fromJson.email, user.email);
      expect(fromJson.role, user.role);
      expect(fromJson.companyId, user.companyId);
    });

    test('UserRole labels are correct', () {
      expect(UserRole.admin.label, 'Admin');
      expect(UserRole.manager.label, 'Yönetici');
      expect(UserRole.procurement.label, 'Satınalma');
    });
  });

  group('RequestModel Tests', () {
    test('RequestModel is created with quantity and urgency', () {
      final request = RequestModel(
        id: 'req1',
        title: 'A4 Kağıt',
        description: 'Ofis için A4 kağıt',
        quantity: 10,
        urgency: 'Acil',
        status: RequestStatus.pending,
        createdBy: 'user1',
        companyId: 'COMP001',
        createdAt: DateTime.now(),
      );

      expect(request.title, 'A4 Kağıt');
      expect(request.quantity, 10);
      expect(request.urgency, 'Acil');
      expect(request.status, RequestStatus.pending);
      expect(request.offers, isEmpty);
    });

    test('RequestStatus labels are correct', () {
      expect(RequestStatus.pending.label, 'Bekliyor');
      expect(RequestStatus.offersReceived.label, 'Teklif Geldi');
      expect(RequestStatus.approved.label, 'Onaylandı');
      expect(RequestStatus.ordered.label, 'Sipariş Oluşturuldu');
      expect(RequestStatus.rejected.label, 'Reddedildi');
      expect(RequestStatus.completed.label, 'Tamamlandı');
    });

    test('OfferModel is created correctly', () {
      final offer = OfferModel(
        id: 'off1',
        requestId: 'req1',
        supplierName: 'TestSupplier',
        price: 100.0,
        currency: 'TL',
        description: 'Test teklif',
      );

      expect(offer.supplierName, 'TestSupplier');
      expect(offer.price, 100.0);
      expect(offer.currency, 'TL');
      expect(offer.isSelected, false);
      expect(offer.paymentMethod, 'Peşin');
      expect(offer.paymentTerm, 0);
    });

    test('Total expense calculation: price * quantity for ordered requests', () {
      final requests = [
        RequestModel(
          id: 'req1',
          title: 'A4 Kağıt',
          description: 'Ofis için',
          quantity: 5,
          urgency: 'Normal',
          status: RequestStatus.ordered,
          createdBy: 'user1',
          companyId: 'COMP001',
          createdAt: DateTime.now(),
          offers: [
            OfferModel(
              id: 'off1',
              requestId: 'req1',
              supplierName: 'Supplier1',
              price: 100.0,
              currency: 'TL',
              description: 'Teklif 1',
              isSelected: true,
            ),
          ],
        ),
        RequestModel(
          id: 'req2',
          title: 'Kalem',
          description: 'Ofis kalemi',
          quantity: 3,
          urgency: 'Acil',
          status: RequestStatus.approved, // Not ordered yet, should NOT be counted
          createdBy: 'user1',
          companyId: 'COMP001',
          createdAt: DateTime.now(),
          offers: [
            OfferModel(
              id: 'off2',
              requestId: 'req2',
              supplierName: 'Supplier2',
              price: 50.0,
              currency: 'TL',
              description: 'Teklif 2',
              isSelected: true,
            ),
          ],
        ),
      ];

      // Calculate total just like admin_home_page.dart does
      final totalAmount = requests
          .where((r) =>
              r.status == RequestStatus.ordered ||
              r.status == RequestStatus.completed)
          .fold(0.0, (sum, r) {
        final selectedOffer = r.offers.firstWhere(
          (o) => o.isSelected,
          orElse: () => OfferModel(
            id: '',
            requestId: '',
            supplierName: '',
            price: 0,
            currency: '',
            description: '',
          ),
        );
        if (selectedOffer.currency == "TL") {
          return sum + (selectedOffer.price * r.quantity);
        }
        return sum;
      });

      // Only req1 should be counted: 100 * 5 = 500
      // req2 is "approved" (not ordered yet), so it should NOT be included
      expect(totalAmount, 500.0);
    });
  });
}
