enum UserRole { admin, manager, procurement }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return "Admin";
      case UserRole.manager:
        return "Yönetici";
      case UserRole.procurement:
        return "Satınalma";
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String companyId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.companyId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
      ),
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.toString().split('.').last,
      'companyId': companyId,
    };
  }
}
