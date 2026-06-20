import 'package:flutter/material.dart';
import '../../shared/widgets/responsive_shell.dart';
import '../../shared/widgets/app_sidebar.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'QUẢN TRỊ HỆ THỐNG',
      accentColor: const Color(0xFFF59E0B),
      child: child,
      items: const [
        NavItem(
          label: 'Cấu hình',
          icon: Icons.settings_outlined,
          activeIcon: Icons.settings,
          path: '/admin',
        ),
        NavItem(
          label: 'Người dùng',
          icon: Icons.people_outline,
          activeIcon: Icons.people,
          path: '/admin/users',
        ),
      ],
    );
  }
}
