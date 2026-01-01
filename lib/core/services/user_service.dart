import 'package:hesapkitap/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserService {
  // Singleton
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final List<UserModel> _users = [
    // Dummy Admin
    UserModel(
      id: '1',
      name: 'Admin User',
      email: 'admin@example.com',
      password: '123',
      role: UserRole.admin,
      companyId: 'COMP001',
    ),
  ];

  UserModel? _currentUser;
  static const String _userKey = 'current_user';

  UserModel? get currentUser => _currentUser;

  // Initialize and load saved user session
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        _currentUser = UserModel.fromJson(json.decode(userJson));
      } catch (e) {
        // If parsing fails, clear the stored data
        await prefs.remove(_userKey);
      }
    }
  }

  Future<void> _saveToPrefs() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(_currentUser!.toJson()));
    }
  }

  Future<void> _removeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      await _saveToPrefs();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerAdmin(
    String name,
    String email,
    String password,
    String companyId,
  ) async {
    // Check if company ID exists (Mock check: only unique companies allowed?)
    // For now, allow any new company ID, but only one admin per company on creation (simplified).
    if (_users.any((u) => u.email == email)) return false;

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: UserRole.admin,
      companyId: companyId,
    );
    _users.add(newUser);
    _currentUser = newUser;
    await _saveToPrefs();
    return true;
  }

  Future<String?> createUser(String name, String email, UserRole role) async {
    if (_currentUser?.role != UserRole.admin) return null;

    // Auto generate password
    final password = "123"; // Simplified

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: role,
      companyId: _currentUser!.companyId,
    );
    _users.add(newUser);
    return password;
  }

  List<UserModel> getUsers() {
    if (_currentUser?.role != UserRole.admin) return [];
    return _users.where((u) => u.companyId == _currentUser!.companyId).toList();
  }

  Future<bool> updateUserRole(String userId, UserRole newRole) async {
    if (_currentUser?.role != UserRole.admin) return false;

    int index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = UserModel(
        id: _users[index].id,
        name: _users[index].name,
        email: _users[index].email,
        password: _users[index].password,
        role: newRole,
        companyId: _users[index].companyId,
      );
      return true;
    }
    return false;
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_currentUser == null) return false;
    if (_currentUser!.password != currentPassword) return false;

    // In a real app, this would be an API call
    final updatedUser = UserModel(
      id: _currentUser!.id,
      name: _currentUser!.name,
      email: _currentUser!.email,
      password: newPassword,
      role: _currentUser!.role,
      companyId: _currentUser!.companyId,
    );

    int index = _users.indexWhere((u) => u.id == _currentUser!.id);
    if (index != -1) {
      _users[index] = updatedUser;
      _currentUser = updatedUser;
      await _saveToPrefs();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _removeFromPrefs();
  }

  void deleteUser(String id) {
    if (_currentUser?.role != UserRole.admin) return;
    _users.removeWhere((u) => u.id == id);
  }
}
