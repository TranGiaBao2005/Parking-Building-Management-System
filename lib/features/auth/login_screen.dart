import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/models.dart';
import '../../core/services/mock_data_service.dart';
import '../../shared/utils/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  final _demoAccounts = [
    {'role': 'Quản lý', 'username': 'manager', 'icon': '👔'},
    {'role': 'Nhân viên', 'username': 'staff1', 'icon': '🧑‍💼'},
    {'role': 'Người gửi xe', 'username': 'driver1', 'icon': '🚘'},
    {'role': 'Quản trị viên', 'username': 'admin', 'icon': '🛠️'},
  ];

  void _login() async {
    final svc = context.read<MockDataService>();
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 600));

    final success = svc.login(_usernameCtrl.text.trim(), _passwordCtrl.text);
    if (!success) {
      setState(() {
        _loading = false;
        _error = 'Tên đăng nhập không đúng. Vui lòng thử lại.';
      });
      return;
    }

    final user = svc.currentUser!;
    setState(() => _loading = false);

    switch (user.role) {
      case UserRole.manager:
        context.go('/manager');
        break;
      case UserRole.staff:
        context.go('/staff');
        break;
      case UserRole.driver:
        context.go('/driver');
        break;
      case UserRole.admin:
        context.go('/admin');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E1B4B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: isMobile
            ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMobileBrandPanel(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: _buildLoginForm(isMobile),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              )
            : Row(
                children: [
                  // Left panel - branding
                  Expanded(
                    flex: 5,
                    child: _buildBrandPanel(),
                  ),
                  // Right panel - login form
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(40),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: _buildLoginForm(isMobile),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMobileBrandPanel() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_parking, color: Colors.white, size: 36),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
          const SizedBox(height: 20),
          Text(
            'Hệ thống Quản lý\nBãi Đậu Xe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.accent],
                ).createShader(const Rect.fromLTWH(0, 0, 300, 100)),
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.3),
          const SizedBox(height: 8),
          Text(
            'SU26SWP08 – Parking System',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        border: const Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_parking, color: Colors.white, size: 40),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),
          const SizedBox(height: 32),
          Text(
            'Hệ thống Quản lý\nBãi Đậu Xe Thông Minh',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.accent],
                ).createShader(const Rect.fromLTWH(0, 0, 400, 100)),
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.3),
          const SizedBox(height: 16),
          Text(
            'SU26SWP08 – Parking Building Management System',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 48),
          // Feature list
          ...[
            (Icons.speed, 'Xử lý xe vào/ra nhanh chóng'),
            (Icons.grid_view, 'Quản lý slot theo thời gian thực'),
            (Icons.analytics, 'Báo cáo & thống kê doanh thu'),
            (Icons.security, 'Kiểm soát ngoại lệ thông minh'),
          ].asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(e.value.$1, color: AppColors.primaryLight, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  e.value.$2,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: Duration(milliseconds: 500 + e.key * 100)).slideX(begin: -0.2),
          )),
        ],
      ),
    );
  }

  Widget _buildLoginForm(bool isMobile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đăng nhập',
          style: isMobile 
              ? Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),
        const SizedBox(height: 8),
        Text(
          'Chọn tài khoản demo bên dưới hoặc nhập thủ công',
          style: isMobile 
              ? Theme.of(context).textTheme.bodySmall
              : Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 32),

        // Demo accounts grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _demoAccounts.map((acc) => _DemoChip(
            icon: acc['icon']!,
            role: acc['role']!,
            username: acc['username']!,
            onTap: () {
              _usernameCtrl.text = acc['username']!;
              _passwordCtrl.text = '123456';
            },
          )).toList(),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 28),

        // Divider
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('hoặc nhập thủ công',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 24),

        // Username
        TextField(
          controller: _usernameCtrl,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Tên đăng nhập',
            prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
          ),
          onSubmitted: (_) => _login(),
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 16),

        // Password
        TextField(
          controller: _passwordCtrl,
          obscureText: _obscure,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: 'Mật khẩu',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          onSubmitted: (_) => _login(),
        ).animate().fadeIn(delay: 400.ms),

        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.red, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),

        // Login button
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _loading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, size: 18),
                      SizedBox(width: 8),
                      Text('Đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
          ),
        ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.3),

        const SizedBox(height: 24),
        Text(
          'Mật khẩu demo: bất kỳ (để trống hoặc nhập gì cũng được)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DemoChip extends StatelessWidget {
  final String icon;
  final String role;
  final String username;
  final VoidCallback onTap;

  const _DemoChip({
    required this.icon,
    required this.role,
    required this.username,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(role,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text('@$username',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
