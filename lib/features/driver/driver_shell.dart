import 'package:flutter/material.dart';
import '../../shared/widgets/responsive_shell.dart';
import '../../shared/widgets/app_sidebar.dart';
import '../../core/theme/app_theme.dart';

class DriverShell extends StatelessWidget {
  final Widget child;
  const DriverShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      title: 'NGƯỜI GỬI XE',
      accentColor: AppColors.accent,
      child: child,
      items: const [
        NavItem(
          label: 'Bãi xe',
          icon: Icons.info_outline,
          activeIcon: Icons.info,
          path: '/driver',
        ),
        NavItem(
          label: 'Lượt gửi',
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long,
          path: '/driver/sessions',
        ),
        NavItem(
          label: 'Đặt chỗ',
          icon: Icons.bookmark_outline,
          activeIcon: Icons.bookmark,
          path: '/driver/booking',
        ),
        NavItem(
          label: 'Phản hồi',
          icon: Icons.feedback_outlined,
          activeIcon: Icons.feedback,
          path: '/driver/feedback',
        ),
      ],
    );
  }
}
