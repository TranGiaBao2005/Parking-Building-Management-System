enum UserRole { manager, staff, driver, admin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.manager:
        return 'Quản lý bãi xe';
      case UserRole.staff:
        return 'Nhân viên bãi xe';
      case UserRole.driver:
        return 'Người gửi xe';
      case UserRole.admin:
        return 'Quản trị viên';
    }
  }

  String get icon {
    switch (this) {
      case UserRole.manager:
        return '👔';
      case UserRole.staff:
        return '🧑‍💼';
      case UserRole.driver:
        return '🚘';
      case UserRole.admin:
        return '🛠️';
    }
  }
}

enum UserStatus { active, inactive }

class AppUser {
  final String id;
  String username;
  String fullName;
  String email;
  String phone;
  UserRole role;
  UserStatus status;
  DateTime createdAt;

  AppUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.status = UserStatus.active,
    required this.createdAt,
  });
}
