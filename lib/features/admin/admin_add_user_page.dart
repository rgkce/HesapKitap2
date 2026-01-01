import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/user_model.dart';

class AdminAddUserPage extends StatefulWidget {
  const AdminAddUserPage({super.key});

  @override
  State<AdminAddUserPage> createState() => _AdminAddUserPageState();
}

class _AdminAddUserPageState extends State<AdminAddUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = UserRole.manager.label;
  final List<String> _roles = [
    UserRole.manager.label,
    UserRole.procurement.label,
  ];
  bool _isLoading = false;

  void _createUser() async {
    setState(() => _isLoading = true);

    UserRole role = UserRole.manager;
    if (_selectedRole == UserRole.procurement.label)
      role = UserRole.procurement;

    final password = await UserService().createUser(
      _nameController.text,
      _emailController.text,
      role,
    );

    setState(() => _isLoading = false);

    if (password != null) {
      if (mounted) {
        _showPasswordDialog(password);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kullanıcı oluşturulamadı.")),
        );
      }
    }
  }

  void _showPasswordDialog(String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Kullanıcı Oluşturuldu"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kullanıcının geçici şifresi:"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      password,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Şifre kopyalandı")),
                        );
                      },
                    ),
                  ],
                ),
                const Text(
                  "Lütfen bu şifreyi kullanıcı ile paylaşın.",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to list
                },
                child: const Text("Tamam"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Kullanıcı Ekle"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kullanıcı Bilgileri", style: AppStyles.heading2),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Ad Soyad",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-mail",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items:
                    _roles
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
                decoration: const InputDecoration(
                  labelText: "Rol Seçiniz",
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Şirket ID: Otomatik atanacak (${UserService().currentUser?.companyId ?? ''})",
                style: AppStyles.caption,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Kullanıcıyı Oluştur",
                            style: AppStyles.buttonText,
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
