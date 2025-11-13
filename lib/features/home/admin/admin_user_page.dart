import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final List<Map<String, String>> _users = [
    {
      "name": "Ahmet Yılmaz",
      "email": "ahmet@example.com",
      "role": "Admin",
      "company": "ABC Holding",
    },
    {
      "name": "Mehmet Can",
      "email": "mehmet@example.com",
      "role": "Satınalma",
      "company": "XYZ A.Ş.",
    },
    {
      "name": "Ayşe Demir",
      "email": "ayse@example.com",
      "role": "Tedarikçi",
      "company": "Demirler Ltd.",
    },
  ];

  final List<String> _roles = [
    "Satınalma",
    "Satınalma Yöneticisi",
    "Yönetici",
    "Tedarikçi",
    "Admin",
  ];

  void _addOrEditUser({Map<String, String>? user, int? index}) {
    final nameController = TextEditingController(text: user?["name"] ?? "");
    final emailController = TextEditingController(text: user?["email"] ?? "");
    final companyController = TextEditingController(
      text: user?["company"] ?? "",
    );
    String selectedRole = user?["role"] ?? _roles.first;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.grey800 : AppColors.grey100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            user == null ? "Yeni Kullanıcı Ekle" : "Kullanıcıyı Düzenle",
            style: AppStyles.heading2.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                  decoration: InputDecoration(
                    labelText: "Ad Soyad",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: companyController,
                  style: AppStyles.bodyText.copyWith(
                    color: isDark ? AppColors.grey200 : AppColors.grey800,
                  ),
                  decoration: InputDecoration(
                    labelText: "Şirket",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  dropdownColor: isDark ? AppColors.grey800 : AppColors.grey200,
                  items:
                      _roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(
                                role,
                                style: AppStyles.bodyText.copyWith(
                                  color:
                                      isDark
                                          ? AppColors.grey200
                                          : AppColors.grey800,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) selectedRole = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Rol Seçiniz",
                    labelStyle: AppStyles.bodyTextBold.copyWith(
                      color: isDark ? AppColors.grey200 : AppColors.grey800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.bodyTextBold.copyWith(color: AppColors.error),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newUser = {
                  "name": nameController.text,
                  "email": emailController.text,
                  "company": companyController.text,
                  "role": selectedRole,
                };

                setState(() {
                  if (user == null) {
                    _users.add(newUser);
                  } else if (index != null) {
                    _users[index] = newUser;
                  }
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              child: Text(
                user == null ? "Ekle" : "Kaydet",
                style: AppStyles.bodyText.copyWith(
                  color: isDark ? AppColors.grey100 : AppColors.grey100,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.grey200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Kullanıcıyı Sil",
            style: AppStyles.heading2.copyWith(color: AppColors.error),
          ),
          content: Text(
            "${_users[index]["name"]} adlı kullanıcıyı silmek istediğinize emin misiniz?",
            style: AppStyles.bodyTextBold.copyWith(
              color: isDark ? AppColors.grey200 : AppColors.grey800,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "İptal",
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.grey200,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _users.removeAt(index);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: Text(
                "Sil",
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.textLight,
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
      onWillPop: () async => false, // geri tuşunu engelle
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Kullanıcı Yönetimi",
                      style: AppStyles.heading1.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return _buildUserCard(user, index);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _addOrEditUser(),
                    icon: const Icon(
                      Icons.person_add,
                      color: AppColors.grey100,
                    ),
                    label: Text(
                      "Yeni Kullanıcı Ekle",
                      style: AppStyles.buttonText.copyWith(
                        color: AppColors.grey100,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildUserCard(Map<String, String> user, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.grey800.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user["name"]!,
            style: AppStyles.bodyTextBold.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 5),
          Text(
            user["email"]!,
            style: AppStyles.bodyText.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 5),
          Text(
            "Şirket: ${user["company"]}",
            style: AppStyles.bodyText.copyWith(color: AppColors.grey200),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user["role"]!,
                style: AppStyles.bodyTextBold.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _addOrEditUser(user: user, index: index),
                    icon: const Icon(Icons.edit, color: AppColors.info),
                  ),
                  IconButton(
                    onPressed: () => _deleteUser(index),
                    icon: const Icon(Icons.delete, color: AppColors.error),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
