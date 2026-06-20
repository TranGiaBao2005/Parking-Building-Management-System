import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';
import 'app_sidebar.dart';

class ResponsiveShell extends StatelessWidget {
  final Widget child;
  final String title;
  final Color accentColor;
  final List<NavItem> items;

  const ResponsiveShell({
    super.key,
    required this.child,
    required this.title,
    required this.accentColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).matchedLocation;
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return _MobileLayout(
        child: child,
        title: title,
        accentColor: accentColor,
        items: items,
        currentPath: path,
      );
    } else {
      return _DesktopLayout(
        child: child,
        title: title,
        accentColor: accentColor,
        items: items,
        currentPath: path,
      );
    }
  }
}

// ── Desktop layout (sidebar) ─────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final Color accentColor;
  final List<NavItem> items;
  final String currentPath;

  const _DesktopLayout({
    required this.child,
    required this.title,
    required this.accentColor,
    required this.items,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            title: title,
            accentColor: accentColor,
            currentPath: currentPath,
            items: items,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ── Mobile layout (bottom nav + appbar) ─────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final Color accentColor;
  final List<NavItem> items;
  final String currentPath;

  const _MobileLayout({
    required this.child,
    required this.title,
    required this.accentColor,
    required this.items,
    required this.currentPath,
  });

  int _currentIndex() {
    // Find the best matching tab index for currentPath
    int bestIndex = 0;
    int bestMatchLen = 0;
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      // Exact match always wins
      if (currentPath == item.path) return i;
      // Prefix match – pick the longest prefix
      if (currentPath.startsWith(item.path) && item.path.length > bestMatchLen) {
        // Avoid root-path false-positives (e.g. /manager matching /manager/slots)
        final afterPrefix = currentPath.substring(item.path.length);
        if (afterPrefix.isEmpty || afterPrefix.startsWith('/')) {
          bestIndex = i;
          bestMatchLen = item.path.length;
        }
      }
    }
    return bestIndex;
  }

  String _currentLabel() {
    final idx = _currentIndex();
    return idx < items.length ? items[idx].label : title;
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final currentIndex = _currentIndex();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        toolbarHeight: ScreenUtils.sh(52),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentLabel(),
              style: TextStyle(
                color: accentColor,
                fontSize: ScreenUtils.sp(15),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: ScreenUtils.sp(10),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
        actions: [
          // User avatar + logout
          if (svc.currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: PopupMenuButton<String>(
                color: AppColors.surfaceLight,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: ScreenUtils.sh(8)),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.sw(10),
                    vertical: ScreenUtils.sh(5),
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        svc.currentUser!.fullName.isNotEmpty
                            ? svc.currentUser!.fullName[0]
                            : 'U',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtils.sp(14),
                        ),
                      ),
                      SizedBox(width: ScreenUtils.sw(4)),
                      Icon(Icons.expand_more, color: accentColor, size: ScreenUtils.sp(16)),
                    ],
                  ),
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          svc.currentUser!.fullName,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          svc.currentUser!.role.label,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'logout',
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.occupied, size: 16),
                        SizedBox(width: 8),
                        Text('Đăng xuất',
                            style: TextStyle(color: AppColors.occupied)),
                      ],
                    ),
                    onTap: () {
                      svc.logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: ScreenUtils.sh(58),
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isActive = i == currentIndex;
                return Expanded(
                  child: _BottomNavItem(
                    item: item,
                    isActive: isActive,
                    accentColor: accentColor,
                    onTap: () => context.go(item.path),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.item,
    required this.isActive,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.sw(10),
                vertical: ScreenUtils.sh(3),
              ),
              decoration: isActive
                  ? BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(ScreenUtils.sw(14)),
                    )
                  : null,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                color: isActive ? accentColor : AppColors.textMuted,
                size: ScreenUtils.sp(22),
              ),
            ),
            SizedBox(height: ScreenUtils.sh(2)),
            Text(
              item.label,
              style: TextStyle(
                color: isActive ? accentColor : AppColors.textMuted,
                fontSize: ScreenUtils.sp(9),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
