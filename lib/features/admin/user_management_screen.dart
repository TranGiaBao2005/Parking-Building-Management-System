import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  static const int _pageSize = 10;
  String _searchQuery = '';
  UserRole? _filterRole;
  int _currentPage = 0;
  final ScrollController _tableScrollController = ScrollController();

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final dtFmt = DateFormat('dd/MM/yyyy');
    final isMobile = Responsive.isMobile(context);

    var users = svc.users.where((u) {
      final matchSearch = _searchQuery.isEmpty ||
          u.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchRole = _filterRole == null || u.role == _filterRole;
      return matchSearch && matchRole;
    }).toList();
    final totalPages =
        users.isEmpty ? 1 : (users.length + _pageSize - 1) ~/ _pageSize;
    if (_currentPage >= totalPages) _currentPage = totalPages - 1;
    final pageUsers =
        users.skip(_currentPage * _pageSize).take(_pageSize).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile)
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      'Quản lý tài khoản',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 22),
                    ),
                  ],
                ),
              ).animate().fadeIn()
            else
              Text('Quản lý tài khoản',
                      style: Theme.of(context).textTheme.displayMedium)
                  .animate()
                  .fadeIn(),
            const SizedBox(height: 16),

            _CreateAccountForm(svc: svc),
            const SizedBox(height: 18),

            // Search and filter
            Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.center,
              children: [
                if (isMobile)
                  TextField(
                    style: const TextStyle(color: AppColors.textPrimary),
                    onChanged: (v) => setState(() {
                      _searchQuery = v;
                      _currentPage = 0;
                    }),
                    decoration: const InputDecoration(
                      hintText: 'Tìm theo tên, username hoặc email...',
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.textSecondary),
                      isDense: true,
                    ),
                  )
                else
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (v) => setState(() {
                        _searchQuery = v;
                        _currentPage = 0;
                      }),
                      decoration: const InputDecoration(
                        hintText: 'Tìm theo tên, username hoặc email...',
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.textSecondary),
                        isDense: true,
                      ),
                    ),
                  ),
                SizedBox(width: isMobile ? 0 : 12, height: isMobile ? 12 : 0),
                if (isMobile)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: UserRole.values.map((role) {
                        return _RoleFilterChip(
                          role: role,
                          selected: _filterRole == role,
                          onTap: () => setState(() {
                            _filterRole = _filterRole == role ? null : role;
                            _currentPage = 0;
                          }),
                        );
                      }).toList(),
                    ),
                  )
                else
                  ...UserRole.values.map((role) {
                    final isSelected = _filterRole == role;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(role.label),
                        selected: isSelected,
                        onSelected: (_) => setState(() {
                          _filterRole = isSelected ? null : role;
                          _currentPage = 0;
                        }),
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),

            // Stats row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: UserRole.values.map((role) {
                  final count = svc.users.where((u) => u.role == role).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Text(role.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(role.label,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                          const SizedBox(width: 6),
                          Text('$count',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.table_rows_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Bảng tài khoản và Role',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${users.length} tài khoản',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // User table
            SizedBox(
              height: 590,
              child: LayoutBuilder(
                builder: (context, tableConstraints) {
                  final tableWidth = tableConstraints.maxWidth > 1050
                      ? tableConstraints.maxWidth
                      : 1050.0;
                  return Scrollbar(
                    controller: _tableScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _tableScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        height: tableConstraints.maxHeight,
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
                                      _UH(flex: 1, text: 'Họ tên'),
                                      _UH(flex: 1, text: 'Username'),
                                      _UH(flex: 1, text: 'Role / Vai trò'),
                                      _UH(flex: 1, text: 'Trạng thái'),
                                      _UH(flex: 1, text: 'Thao tác'),
                                    ],
                                  ),
                                ),
                                const Divider(
                                    color: AppColors.border, height: 1),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: pageUsers.length,
                                    separatorBuilder: (_, __) => const Divider(
                                        color: AppColors.border, height: 1),
                                    itemBuilder: (context, i) {
                                      final user = pageUsers[i];
                                      final isActive =
                                          user.status == UserStatus.active;
                                      return Row(
                                        children: [
                                          _UC(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        user.fullName.isNotEmpty
                                                            ? user.fullName[0]
                                                            : 'U',
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(user.fullName,
                                                        style: const TextStyle(
                                                            color: AppColors
                                                                .textPrimary,
                                                            fontSize: 13),
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ],
                                              )),
                                          _UC(
                                              flex: 1,
                                              child: Text('@${user.username}',
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .textSecondary,
                                                      fontSize: 12))),
                                          _UC(
                                              flex: 1,
                                              child: Text(
                                                  '${user.role.icon} ${user.role.label}',
                                                  style: const TextStyle(
                                                      color: AppColors
                                                          .textSecondary,
                                                      fontSize: 11))),
                                          _UC(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: (isActive
                                                            ? AppColors
                                                                .available
                                                            : AppColors
                                                                .textMuted)
                                                        .withOpacity(0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    isActive
                                                        ? 'Hoạt động'
                                                        : 'Vô hiệu hóa',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.visible,
                                                    style: TextStyle(
                                                      color: isActive
                                                          ? AppColors.available
                                                          : AppColors.textMuted,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          _UC(
                                              flex: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  _UserActionButton(
                                                    tooltip: 'Chi tiết',
                                                    icon: Icons
                                                        .visibility_outlined,
                                                    color: AppColors.primary,
                                                    onPressed: () =>
                                                        _showUserDetails(
                                                            context,
                                                            user,
                                                            dtFmt),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  _UserActionButton(
                                                    tooltip: 'Chỉnh sửa',
                                                    icon: Icons.edit_outlined,
                                                    color: AppColors.reserved,
                                                    onPressed: () =>
                                                        _showEditUserDialog(
                                                            context, svc, user),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  _UserActionButton(
                                                    tooltip: 'Xóa',
                                                    icon: Icons.delete_outline,
                                                    color: AppColors.occupied,
                                                    onPressed: () =>
                                                        _confirmDeleteUser(
                                                            context, svc, user),
                                                  ),
                                                ],
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
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 14),
            _PaginationBar(
              currentPage: _currentPage,
              totalPages: totalPages,
              totalItems: users.length,
              pageSize: _pageSize,
              onPageChanged: (page) => setState(() => _currentPage = page),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showUserDetails(
      BuildContext context, AppUser user, DateFormat dtFmt) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.account_circle_outlined, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Chi tiết tài khoản',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _UserDetailRow(label: 'ID', value: user.id),
                _UserDetailRow(label: 'Họ tên', value: user.fullName),
                _UserDetailRow(label: 'Username', value: user.username),
                _UserDetailRow(label: 'Email', value: user.email),
                _UserDetailRow(label: 'Số điện thoại', value: user.phone),
                _UserDetailRow(label: 'Role', value: user.role.label),
                _UserDetailRow(
                  label: 'Trạng thái',
                  value: user.status == UserStatus.active
                      ? 'Hoạt động'
                      : 'Vô hiệu',
                ),
                _UserDetailRow(
                    label: 'Ngày tạo', value: dtFmt.format(user.createdAt)),
                const _UserDetailRow(
                  label: 'Mật khẩu',
                  value: '••••••••  (được ẩn vì bảo mật)',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditUserDialog(
      BuildContext context, MockDataService svc, AppUser user) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user.fullName);
    final usernameCtrl = TextEditingController(text: user.username);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    var role = user.role;
    var status = user.status;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Chỉnh sửa tài khoản'),
          content: SizedBox(
            width: 460,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Họ tên đầy đủ'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Vui lòng nhập họ tên'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: usernameCtrl,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Vui lòng nhập username'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: 'Số điện thoại'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<UserRole>(
                      value: role,
                      decoration:
                          const InputDecoration(labelText: 'Role / Vai trò'),
                      items: UserRole.values
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text('${item.icon} ${item.label}'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => role = value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<UserStatus>(
                      value: status,
                      decoration:
                          const InputDecoration(labelText: 'Trạng thái'),
                      items: const [
                        DropdownMenuItem(
                            value: UserStatus.active, child: Text('Hoạt động')),
                        DropdownMenuItem(
                            value: UserStatus.inactive, child: Text('Vô hiệu')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => status = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) {
      svc.updateUser(
        userId: user.id,
        username: usernameCtrl.text.trim(),
        fullName: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        role: role,
        status: status,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cập nhật ${nameCtrl.text.trim()}')),
        );
      }
    }

    nameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
  }

  Future<void> _confirmDeleteUser(
      BuildContext context, MockDataService svc, AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Xóa tài khoản?'),
        content: Text(
          'Bạn có chắc muốn xóa tài khoản ${user.fullName} (@${user.username})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.occupied),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final deleted = svc.deleteUser(user.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted
            ? 'Đã xóa tài khoản ${user.fullName}'
            : 'Không thể xóa tài khoản đang đăng nhập'),
      ),
    );
  }
}

class _CreateAccountForm extends StatefulWidget {
  final MockDataService svc;

  const _CreateAccountForm({required this.svc});

  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  UserRole _role = UserRole.staff;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
      ),
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 700;
            final fieldWidth = isCompact
                ? constraints.maxWidth
                : (constraints.maxWidth - 36) / 4;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_add_alt_1_outlined,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Form tạo tài khoản',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration:
                            const InputDecoration(labelText: 'Họ tên đầy đủ'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Vui lòng nhập họ tên'
                                : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: _usernameCtrl,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Vui lòng nhập username'
                                : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration:
                            const InputDecoration(labelText: 'Số điện thoại'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isCompact)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildRoleField(),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Tạo tài khoản'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      SizedBox(width: 250, child: _buildRoleField()),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Tạo tài khoản'),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoleField() {
    return DropdownButtonFormField<UserRole>(
      value: _role,
      dropdownColor: AppColors.surfaceLight,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: const InputDecoration(labelText: 'Role / Vai trò'),
      items: UserRole.values
          .map((role) => DropdownMenuItem(
                value: role,
                child: Text('${role.icon} ${role.label}'),
              ))
          .toList(),
      onChanged: (role) {
        if (role != null) setState(() => _role = role);
      },
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final createdName = _nameCtrl.text.trim();
    widget.svc.addUser(
      AppUser(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        username: _usernameCtrl.text.trim(),
        fullName: createdName,
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        role: _role,
        createdAt: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã tạo tài khoản $createdName')),
    );
    _nameCtrl.clear();
    _usernameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    setState(() => _role = UserRole.staff);
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = totalItems == 0 ? 0 : currentPage * pageSize + 1;
    final lastItem = totalItems == 0
        ? 0
        : ((currentPage + 1) * pageSize).clamp(0, totalItems);
    final controls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PageButton(
          icon: Icons.chevron_left,
          tooltip: 'Trang trước',
          enabled: currentPage > 0,
          onPressed: () => onPageChanged(currentPage - 1),
        ),
        const SizedBox(width: 6),
        ...List.generate(totalPages, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _PageButton(
              label: '${index + 1}',
              selected: index == currentPage,
              onPressed: () => onPageChanged(index),
            ),
          );
        }),
        _PageButton(
          icon: Icons.chevron_right,
          tooltip: 'Trang sau',
          enabled: currentPage < totalPages - 1,
          onPressed: () => onPageChanged(currentPage + 1),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final summary = Text(
          'Hiển thị $firstItem–$lastItem / $totalItems tài khoản',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        );
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summary,
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: controls,
              ),
            ],
          );
        }
        return Row(
          children: [
            summary,
            const Spacer(),
            controls,
          ],
        );
      },
    );
  }
}

class _PageButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? tooltip;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  const _PageButton({
    this.label,
    this.icon,
    this.tooltip,
    this.selected = false,
    this.enabled = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;
    final button = InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.18)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.border),
        ),
        child: icon != null
            ? Icon(icon, size: 19, color: enabled ? color : AppColors.textMuted)
            : Text(
                label ?? '',
                style: TextStyle(
                  color: enabled ? color : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

class _UserActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _UserActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
      ),
    );
  }
}

class _UserDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _UserDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleFilterChip extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleFilterChip({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(role.label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
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
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
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
