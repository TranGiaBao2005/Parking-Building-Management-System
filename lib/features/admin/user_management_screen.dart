import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  UserRole? _filterRole;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final dtFmt = DateFormat('dd/MM/yyyy');

    var users = svc.users.where((u) {
      final matchSearch = _searchQuery.isEmpty ||
          u.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchRole = _filterRole == null || u.role == _filterRole;
      return matchSearch && matchRole;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quản lý người dùng', style: Theme.of(context).textTheme.displayMedium),
                ElevatedButton.icon(
                  onPressed: () => _showAddUserDialog(context, svc),
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Thêm tài khoản'),
                ),
              ],
            ).animate().fadeIn(),
            const SizedBox(height: 20),

            // Search and filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: 'Tìm theo tên, username hoặc email...',
                      prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ...UserRole.values.map((role) {
                  final isSelected = _filterRole == role;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(role.label),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _filterRole = isSelected ? null : role),
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: UserRole.values.map((role) {
                final count = svc.users.where((u) => u.role == role).length;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Text(role.icon, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(role.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(width: 6),
                        Text('$count',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 20),

            // User table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        color: AppColors.surfaceLight,
                        child: const Row(
                          children: [
                            _UH(flex: 2, text: 'Họ tên'),
                            _UH(flex: 2, text: 'Username'),
                            _UH(flex: 3, text: 'Email'),
                            _UH(flex: 1, text: 'Vai trò'),
                            _UH(flex: 1, text: 'Trạng thái'),
                            _UH(flex: 1, text: 'Ngày tạo'),
                            _UH(flex: 1, text: 'Thao tác'),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.border, height: 1),
                      Expanded(
                        child: ListView.separated(
                          itemCount: users.length,
                          separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
                          itemBuilder: (context, i) {
                            final user = users[i];
                            final isActive = user.status == UserStatus.active;
                            return Row(
                              children: [
                                _UC(flex: 2, child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          user.fullName.isNotEmpty ? user.fullName[0] : 'U',
                                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(user.fullName,
                                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                                _UC(flex: 2, child: Text('@${user.username}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                                _UC(flex: 3, child: Text(user.email,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    overflow: TextOverflow.ellipsis)),
                                _UC(flex: 1, child: Text('${user.role.icon} ${user.role.label}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11))),
                                _UC(flex: 1, child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (isActive ? AppColors.available : AppColors.textMuted).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isActive ? 'Hoạt động' : 'Vô hiệu',
                                    style: TextStyle(
                                        color: isActive ? AppColors.available : AppColors.textMuted,
                                        fontSize: 10),
                                  ),
                                )),
                                _UC(flex: 1, child: Text(dtFmt.format(user.createdAt),
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11))),
                                _UC(flex: 1, child: Switch(
                                  value: isActive,
                                  activeColor: AppColors.available,
                                  onChanged: (_) => svc.toggleUserStatus(user.id),
                                )),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, MockDataService svc) {
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    UserRole role = UserRole.staff;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Thêm tài khoản mới', style: TextStyle(color: AppColors.textPrimary)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Họ tên đầy đủ'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: userCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<UserRole>(
                  value: role,
                  dropdownColor: AppColors.surfaceLight,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Vai trò'),
                  items: UserRole.values.map((r) => DropdownMenuItem(
                    value: r,
                    child: Text('${r.icon} ${r.label}'),
                  )).toList(),
                  onChanged: (r) => setDialog(() => role = r!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty || userCtrl.text.isEmpty) return;
                svc.addUser(AppUser(
                  id: 'u${DateTime.now().millisecondsSinceEpoch}',
                  username: userCtrl.text,
                  fullName: nameCtrl.text,
                  email: emailCtrl.text,
                  phone: phoneCtrl.text,
                  role: role,
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm tài khoản ${nameCtrl.text}')),
                );
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UH extends StatelessWidget {
  final int flex;
  final String text;
  const _UH({required this.flex, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Text(text,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _UC extends StatelessWidget {
  final int flex;
  final Widget child;
  const _UC({required this.flex, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: child,
      ),
    );
  }
}
