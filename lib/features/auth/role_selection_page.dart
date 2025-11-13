import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/home/admin/admin_home_page.dart';
import 'package:hesapkitap/features/home/approver/approver_home_page.dart';
import 'package:hesapkitap/features/home/customer/customer_dashboard_page.dart.dart';
import 'package:hesapkitap/features/home/customer_approver/customapprover_home_page.dart';
import 'package:hesapkitap/features/home/supplier/supplier_home_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({
    super.key,
    required String name,
    required String email,
  });

  Future<bool> _onWillPop() async => false; // Telefon geri tuşunu engelle

  void _navigateToRolePage(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (_) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.grey800 : AppColors.grey100, // Arka plan
          title: Text(
            "Seçiminizi onaylıyor musunuz?",
            style: AppStyles.heading3.copyWith(
              color: isDark ? AppColors.grey100 : AppColors.grey800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Hayır",
                style: AppStyles.buttonText.copyWith(
                  color:
                      isDark
                          ? AppColors.warning.withOpacity(0.9)
                          : AppColors.warning,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Widget page;
                switch (role) {
                  case 'admin':
                    page = const AdminHomePage();
                    break;
                  case 'approver':
                    page = const ApproverHomePage();
                    break;
                  case 'supplier':
                    page = const SupplierHomePage();
                    break;
                  case 'customer':
                    page = const CustomerDashboardPage();
                    break;
                  case 'customer approver':
                    page = const CustomApproverHomePage();
                    break;
                  default:
                    page = const AdminHomePage();
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              },
              child: Text(
                "Evet",
                style: AppStyles.buttonText.copyWith(
                  color:
                      isDark
                          ? AppColors.success.withOpacity(0.9)
                          : AppColors.success,
                ),
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
      onWillPop: _onWillPop,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Rolünüzü Seçin",
                    style: AppStyles.heading1.copyWith(
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  // Rol Butonları
                  _roleButton(
                    context,
                    'Admin',
                    Icons.admin_panel_settings,
                    'admin',
                  ),
                  const SizedBox(height: 20),
                  _roleButton(
                    context,
                    'Yönetici',
                    Icons.verified_user,
                    'approver',
                  ),
                  const SizedBox(height: 20),
                  _roleButton(context, 'Tedarikçi', Icons.person, 'supplier'),
                  const SizedBox(height: 20),
                  _roleButton(
                    context,
                    'Satınalma',
                    Icons.shopping_cart,
                    'customer',
                  ),
                  const SizedBox(height: 20),
                  _roleButton(
                    context,
                    'Satınalma Yöneticisi',
                    Icons.shopping_cart_checkout,
                    'customer approver',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleButton(
    BuildContext context,
    String title,
    IconData icon,
    String role,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () => _navigateToRolePage(context, role),
        icon: Icon(icon, size: 30, color: AppColors.accent),
        label: Text(
          title,
          style: AppStyles.buttonText.copyWith(
            fontSize: 20,
            color: isDark ? AppColors.grey200 : AppColors.grey800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
