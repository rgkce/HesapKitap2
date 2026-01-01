import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_theme.dart';
import 'package:hesapkitap/features/auth/forgot_password_page.dart';
import 'package:hesapkitap/features/auth/change_password_page.dart';
import 'package:hesapkitap/features/auth/login_page.dart';

import 'package:hesapkitap/features/auth/signup_page.dart';
import 'package:hesapkitap/features/admin/admin_home_page.dart';
import 'package:hesapkitap/features/admin/admin_all_requests_page.dart';
import 'package:hesapkitap/features/admin/admin_user_page.dart';
import 'package:hesapkitap/features/admin/admin_reports_page.dart';
import 'package:hesapkitap/features/procurement/procurement_home_page.dart';
import 'package:hesapkitap/features/procurement/procurement_profile_page.dart';
import 'package:hesapkitap/features/procurement/procurement_reports_page.dart';
import 'package:hesapkitap/features/procurement/procurement_requests_page.dart';
import 'package:hesapkitap/features/procurement/procurement_add_quote_page.dart';

import 'package:hesapkitap/features/manager/manager_create_request_page.dart';
import 'package:hesapkitap/features/manager/manager_home_page.dart';
import 'package:hesapkitap/features/admin/admin_profile_page.dart';
import 'package:hesapkitap/features/manager/manager_offers_page.dart';
import 'package:hesapkitap/features/manager/manager_profile_page.dart';
import 'package:hesapkitap/features/manager/manager_reports_page.dart';

import 'package:hesapkitap/features/splash/splash_screen.dart';
import 'package:hesapkitap/core/services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService().init();
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
        '/change_password': (context) => const ChangePasswordPage(),
        // Admin Routes
        '/admin_home': (context) => const AdminHomePage(),
        '/admin_users': (context) => const AdminUsersPage(),
        '/admin_requests': (context) => const AdminAllRequestsPage(),
        '/admin_reports': (context) => const AdminReportsPage(),
        '/admin_profile': (context) => const AdminProfilePage(),
        // Procurement Routes
        '/procurement_home': (context) => const ProcurementHomePage(),
        '/procurement_requests': (context) => const ProcurementRequestsPage(),
        '/procurement_reports': (context) => const ProcurementReportsPage(),
        '/procurement_add_quote': (context) => const ProcurementAddQuotePage(),
        '/procurement_profile': (context) => const ProcurementProfilePage(),
        // Manager Routes
        '/manager_home': (context) => const ManagerHomePage(),
        '/manager_offers': (context) => const ManagerOffersPage(),
        '/manager_reports': (context) => const ManagerReportsPage(),
        '/manager_profile': (context) => const ManagerProfilePage(),
        '/manager_createrequest': (context) => const ManagerCreateRequestPage(),
      },
    );
  }
}
