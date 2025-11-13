import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_theme.dart';
import 'package:hesapkitap/features/auth/forgot_password_page.dart';
import 'package:hesapkitap/features/auth/login_page.dart';
import 'package:hesapkitap/features/auth/role_selection_page.dart';
import 'package:hesapkitap/features/auth/signup_page.dart';
import 'package:hesapkitap/features/home/admin/admin_home_page.dart';
import 'package:hesapkitap/features/home/admin/admin_reports_page.dart';
import 'package:hesapkitap/features/home/admin/admin_user_page.dart';
import 'package:hesapkitap/features/home/approver/approver_home_page.dart';
import 'package:hesapkitap/features/home/approver/approver_profile_page.dart';
import 'package:hesapkitap/features/home/approver/approver_reports_page.dart';
import 'package:hesapkitap/features/home/approver/approver_request_page.dart';
import 'package:hesapkitap/features/home/approver/approversupplier_page.dart';
import 'package:hesapkitap/features/home/customer/customer_create_request_page.dart';
import 'package:hesapkitap/features/home/customer/customer_dashboard_page.dart.dart';
import 'package:hesapkitap/features/home/admin/admin_profile_page.dart';
import 'package:hesapkitap/features/home/customer/customer_offers_page.dart';
import 'package:hesapkitap/features/home/customer/customer_profile_page.dart';
import 'package:hesapkitap/features/home/customer/customer_reports_page.dart';
import 'package:hesapkitap/features/home/customer_approver/customapprover_home_page.dart';
import 'package:hesapkitap/features/home/customer_approver/customapprover_offers_page.dart';
import 'package:hesapkitap/features/home/customer_approver/customapprover_profile_page.dart';
import 'package:hesapkitap/features/home/customer_approver/customapprover_reports_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_home_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_payments_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_profile_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_reports_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_request_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_stock_page.dart';
import 'package:hesapkitap/features/splash/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HesapKitap',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Sisteme göre tema seçimi
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/roleSelection':
            (context) => const RoleSelectionPage(name: '', email: ''),
        // Admin Routes
        '/admin_home': (context) => const AdminHomePage(),
        '/admin_users': (context) => const AdminUsersPage(),
        '/admin_reports': (context) => const AdminReportsPage(),
        '/admin_profile': (context) => const AdminProfilePage(),
        //Approver Routes
        '/approver_home': (context) => const ApproverHomePage(),
        '/approver_requests': (context) => const ApproverRequestsPage(),
        '/approver_reports': (context) => const ApproverReportsPage(),
        '/approver_suppliers': (context) => const ApproverSuppliersPage(),
        '/approver_profile': (context) => const ApproverProfilePage(),
        //Supplier Routes
        '/supplier_home': (context) => const SupplierHomePage(),
        '/supplier_requests': (context) => const SupplierRequestsPage(),
        '/supplier_reports': (context) => const SupplierReportsPage(),
        '/supplier_profile': (context) => const SupplierProfilePage(),
        '/supplier_stock': (context) => const SupplierStockPage(),
        '/supplier_payments': (context) => const SupplierPaymentsPage(),
        //Customer Routes
        '/customer_home': (context) => const CustomerDashboardPage(),
        '/customer_offers': (context) => CustomerOffersPage(),
        '/customer_reports': (context) => const CustomerReportsPage(),
        '/customer_profile': (context) => const CustomerProfilePage(),
        '/customer_createrequest':
            (context) => const CustomerCreateRequestPage(),
        //Customer Approver Routes
        '/customapprover_home': (context) => const CustomApproverHomePage(),
        '/customapprover_offers': (context) => CustomApproverOffersPage(),
        '/customapprover_reports':
            (context) => const CustomApproverReportsPage(),
        '/customapprover_profile':
            (context) => const CustomApproverProfilePage(),
      },
    );
  }
}
