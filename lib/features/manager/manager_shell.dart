import 'package:flutter/material.dart';
import '../../shared/widgets/responsive_shell.dart';
import '../../shared/widgets/app_sidebar.dart';
import '../../core/theme/app_theme.dart';

class ManagerShell extends StatelessWidget {
  final Widget child;
  const ManagerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'QUẢN LÝ BÃI XE',
      accentColor: AppColors.primary,
      child: child,
      items: const [
        NavItem(
          label: 'Tổng quan',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
          path: '/manager',
        ),
        NavItem(
          label: 'Quản lý Slot',
          icon: Icons.grid_view_outlined,
          activeIcon: Icons.grid_view,
          path: '/manager/slots',
        ),
        NavItem(
          label: 'Chính sách giá',
          icon: Icons.price_change_outlined,
          activeIcon: Icons.price_change,
          path: '/manager/pricing',
        ),
        NavItem(
          label: 'Báo cáo',
          icon: Icons.analytics_outlined,
          activeIcon: Icons.analytics,
          path: '/manager/reports',
        ),
        NavItem(
          label: 'Ngoại lệ',
          icon: Icons.warning_amber_outlined,
          activeIcon: Icons.warning_amber_rounded,
          path: '/manager/exceptions',
        ),
      ],
    );
  }
}
