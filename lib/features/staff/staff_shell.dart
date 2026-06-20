import 'package:flutter/material.dart';
import '../../shared/widgets/responsive_shell.dart';
import '../../shared/widgets/app_sidebar.dart';

class StaffShell extends StatelessWidget {
  final Widget child;
  const StaffShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'NHÂN VIÊN BÃI XE',
      accentColor: const Color(0xFF10B981),
      child: child,
      items: const [
        NavItem(
          label: 'Xe vào',
          icon: Icons.login_outlined,
          activeIcon: Icons.login,
          path: '/staff',
        ),
        NavItem(
          label: 'Xe ra',
          icon: Icons.logout_outlined,
          activeIcon: Icons.logout,
          path: '/staff/checkout',
        ),
        NavItem(
          label: 'Ngoại lệ',
          icon: Icons.warning_amber_outlined,
          activeIcon: Icons.warning_amber,
          path: '/staff/exceptions',
        ),
      ],
    );
  }
}
