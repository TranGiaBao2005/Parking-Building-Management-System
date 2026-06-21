import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../features/landing/landing_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/manager/manager_shell.dart';
import '../../features/manager/dashboard_screen.dart';
import '../../features/manager/slot_management_screen.dart';
import '../../features/manager/pricing_screen.dart';
import '../../features/manager/reports_screen.dart';
import '../../features/manager/exception_management_screen.dart';
import '../../features/staff/staff_shell.dart';
import '../../features/staff/check_in_screen.dart';
import '../../features/staff/check_out_screen.dart';
import '../../features/staff/exception_screen.dart';
import '../../features/driver/driver_shell.dart';
import '../../features/driver/driver_dashboard_screen.dart';
import '../../features/driver/my_sessions_screen.dart';
import '../../features/driver/prebooking_screen.dart';
import '../../features/driver/feedback_screen.dart';
import '../../features/admin/admin_shell.dart';
import '../../features/admin/system_config_screen.dart';
import '../../features/admin/user_management_screen.dart';

final appRouter = GoRouter(
  initialLocation: kIsWeb ? '/' : '/login',
  redirect: (context, state) {
    final svc = context.read<MockDataService>();
    final loggedIn = svc.currentUser != null;
    final loc = state.matchedLocation;
    final isGoingToLogin = loc == '/login';
    final isGoingToLanding = loc == '/';

    if (!loggedIn) {
      if (kIsWeb && isGoingToLanding) return null;
      if (isGoingToLogin) return null;
      return kIsWeb ? '/' : '/login';
    }

    if (loggedIn && (isGoingToLogin || isGoingToLanding)) {
      switch (svc.currentUser!.role) {
        case UserRole.manager:
          return '/manager';
        case UserRole.staff:
          return '/staff';
        case UserRole.driver:
          return '/driver';
        case UserRole.admin:
          return '/admin';
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          kIsWeb ? const LandingScreen() : const LoginScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Manager
    ShellRoute(
      builder: (context, state, child) => ManagerShell(child: child),
      routes: [
        GoRoute(
          path: '/manager',
          builder: (context, state) => const ManagerDashboardScreen(),
        ),
        GoRoute(
          path: '/manager/slots',
          builder: (context, state) => const SlotManagementScreen(),
        ),
        GoRoute(
          path: '/manager/pricing',
          builder: (context, state) => const PricingScreen(),
        ),
        GoRoute(
          path: '/manager/reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        GoRoute(
          path: '/manager/exceptions',
          builder: (context, state) => const ExceptionManagementScreen(),
        ),
      ],
    ),

    // Staff
    ShellRoute(
      builder: (context, state, child) => StaffShell(child: child),
      routes: [
        GoRoute(
          path: '/staff',
          builder: (context, state) => const CheckInScreen(),
        ),
        GoRoute(
          path: '/staff/checkout',
          builder: (context, state) => const CheckOutScreen(),
        ),
        GoRoute(
          path: '/staff/exceptions',
          builder: (context, state) => const ExceptionScreen(),
        ),
      ],
    ),

    // Driver
    ShellRoute(
      builder: (context, state, child) => DriverShell(child: child),
      routes: [
        GoRoute(
          path: '/driver',
          builder: (context, state) => const DriverDashboardScreen(),
        ),
        GoRoute(
          path: '/driver/sessions',
          builder: (context, state) => const MySessionsScreen(),
        ),
        GoRoute(
          path: '/driver/booking',
          builder: (context, state) => const PrebookingScreen(),
        ),
        GoRoute(
          path: '/driver/feedback',
          builder: (context, state) => const FeedbackScreen(),
        ),
      ],
    ),

    // Admin
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const SystemConfigScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (context, state) => const UserManagementScreen(),
        ),
      ],
    ),
  ],
);
