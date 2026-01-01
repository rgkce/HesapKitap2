import 'package:flutter/material.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';
import 'package:hesapkitap/core/widgets/app_dialog.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserService().currentUser;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.grey200,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.grey600,
                ),
              ),
              const SizedBox(height: 20),
              Text(user?.name ?? "Admin", style: AppStyles.heading2),
              const SizedBox(height: 5),
              Text(
                user?.email ?? "",
                style: AppStyles.bodyText.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      title: "Şifre Değiştir",
                      icon: Icons.lock_outline,
                      onTap:
                          () =>
                              Navigator.pushNamed(context, '/change_password'),
                    ),
                    _buildProfileItem(
                      context,
                      title: "Çıkış Yap",
                      icon: Icons.logout,
                      isDestructive: true,
                      onTap: () => _logout(context),
                    ),
                    _buildProfileItem(
                      context,
                      title: "Hesabı Sil",
                      icon: Icons.delete_forever,
                      isDestructive: true,
                      onTap:
                          () => AppDialog.show(
                            context,
                            title: "Hesabı Sil",
                            message:
                                "Hesabınızı kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
                            isDestructive: true,
                            onConfirm: () async {
                              await UserService().logout();
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
            ],
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 4),
      ),
    );
  }

  void _logout(BuildContext context) {
    AppDialog.show(
      context,
      title: "Çıkış Yap",
      message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
      onConfirm: () async {
        await UserService().logout();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isDestructive
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.error : AppColors.info,
          ),
        ),
        title: Text(
          title,
          style: AppStyles.bodyTextBold.copyWith(
            color: isDestructive ? AppColors.error : AppColors.info,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
