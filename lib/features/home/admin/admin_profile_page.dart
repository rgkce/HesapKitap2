import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    VoidCallback onConfirm,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor:
                isDark ? AppColors.grey800 : AppColors.grey100, // Arka plan
            title: Text(
              title,
              style: AppStyles.heading2.copyWith(
                color: isDark ? AppColors.grey200 : AppColors.grey800,
              ),
            ),
            content: Text(
              "Bu işlemi yapmak istediğinize emin misiniz?",
              style: AppStyles.heading3.copyWith(
                color: isDark ? AppColors.grey200 : AppColors.grey800,
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
                  onConfirm();
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
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false, // Telefonun geri tuşunu engelle
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.grey800,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Rümeysa Gökçe Admin",
                  style: AppStyles.heading1.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "gokce@example.com",
                  style: AppStyles.bodyText.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Şifre Değiştir
                        _buildButton(
                          context,
                          title: "Şifre Değiştir",
                          icon: Icons.lock_open,
                          color: AppColors.info.withOpacity(0.85),
                          onPressed:
                              () => _showConfirmationDialog(
                                context,
                                "Şifre Değiştir",
                                () {
                                  Navigator.pushNamed(
                                    context,
                                    '/change_password',
                                  );
                                },
                              ),
                        ),
                        const SizedBox(height: 20),
                        // Çıkış Yap
                        _buildButton(
                          context,
                          title: "Çıkış Yap",
                          icon: Icons.logout,
                          color: AppColors.warning.withOpacity(0.85),
                          onPressed:
                              () => _showConfirmationDialog(
                                context,
                                "Çıkış Yap",
                                () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                              ),
                        ),
                        const SizedBox(height: 20),
                        // Hesabı Sil
                        _buildButton(
                          context,
                          title: "Hesabı Sil",
                          icon: Icons.delete_forever,
                          color: AppColors.error.withOpacity(0.85),
                          onPressed:
                              () => _showConfirmationDialog(
                                context,
                                "Hesabı Sil",
                                () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/signup',
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.grey100, size: 25),
        label: Text(
          title,
          style: AppStyles.buttonText.copyWith(
            color: AppColors.grey100,
            fontSize: 20,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
