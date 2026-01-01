import 'package:flutter/material.dart';
import 'package:hesapkitap/core/theme/app_colors.dart';
import 'package:hesapkitap/core/theme/app_styles.dart';
import 'package:hesapkitap/features/navigation/admin_navbar.dart';
import 'package:hesapkitap/core/services/user_service.dart';
import 'package:hesapkitap/core/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:hesapkitap/features/admin/admin_add_user_page.dart';
import 'package:hesapkitap/core/widgets/app_dialog.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final users = UserService().getUsers();
    setState(() {
      _users = users;
      _filteredUsers = users;
      _isLoading = false;
    });
    _filterUsers(_searchController.text);
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers =
            _users
                .where(
                  (user) =>
                      user.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  void _addUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminAddUserPage()),
    ).then((_) => _loadUsers());
  }

  void _deleteUser(String id) {
    UserService().deleteUser(id);
    _loadUsers();
  }

  void _changeRole(UserModel user) async {
    UserRole? newRole = await showDialog<UserRole>(
      context: context,
      builder:
          (context) => SimpleDialog(
            title: const Text("Rolü Değiştir"),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, UserRole.manager),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UserRole.manager.label),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, UserRole.procurement),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(UserRole.procurement.label),
                ),
              ),
            ],
          ),
    );

    if (newRole != null && newRole != user.role) {
      final success = await UserService().updateUserRole(user.id, newRole);
      if (success) {
        _loadUsers();
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Rol güncellendi")));
      }
    }
  }

  void _showDeleteConfirm(String id, String name) {
    AppDialog.show(
      context,
      title: "Kullanıcıyı Sil",
      message:
          "$name adlı kullanıcıyı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
      isDestructive: true,
      onConfirm: () => _deleteUser(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kullanıcı Yönetimi"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterUsers,
                  decoration: InputDecoration(
                    hintText: "Kullanıcı Ara...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterUsers('');
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.grey200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.grey200),
                    ),
                    filled: true,
                    fillColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredUsers.isEmpty
                          ? Center(
                            child: Text(
                              "Kullanıcı bulunamadı",
                              style: AppStyles.bodyText.copyWith(
                                color: AppColors.grey600,
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return _buildUserCard(user);
                            },
                          ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addUser,
                    icon: const Icon(Icons.person_add),
                    label: const Text("Yeni Kullanıcı Ekle"),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AdminNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name,
                  style: AppStyles.bodyTextBold.copyWith(fontSize: 16),
                ),
                if (user.role != UserRole.admin)
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.info, size: 20),
                    onPressed: () => _changeRole(user),
                    tooltip: "Rolü Değiştir",
                  ),
              ],
            ),
            Text(
              user.email,
              style: AppStyles.bodyText.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Text(
                user.role.label.toUpperCase(),
                style: AppStyles.bodyText.copyWith(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (user.role != UserRole.admin) ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirm(user.id, user.name),
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.error,
                      size: 18,
                    ),
                    label: const Text(
                      "Sil",
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
