import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class SystemConfigScreen extends StatefulWidget {
  const SystemConfigScreen({super.key});

  @override
  State<SystemConfigScreen> createState() => _SystemConfigScreenState();
}

class _SystemConfigScreenState extends State<SystemConfigScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _addrCtrl;
  late TextEditingController _openCtrl;
  late TextEditingController _closeCtrl;
  bool _editing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final svc = context.read<MockDataService>();
    _nameCtrl = TextEditingController(text: svc.buildingName);
    _addrCtrl = TextEditingController(text: svc.buildingAddress);
    _openCtrl = TextEditingController(text: svc.openTime);
    _closeCtrl = TextEditingController(text: svc.closeTime);
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final totalSlots = svc.slots.length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cấu hình hệ thống', style: Theme.of(context).textTheme.displayMedium)
                .animate().fadeIn(),
            const SizedBox(height: 8),
            const Text('Quản lý kỹ thuật và cài đặt hệ thống.',
                style: TextStyle(color: AppColors.textSecondary))
                .animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 32),

            // Building info card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Thông tin tòa nhà', style: Theme.of(context).textTheme.titleLarge),
                            if (!_editing)
                              TextButton.icon(
                                onPressed: () => setState(() => _editing = true),
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: const Text('Chỉnh sửa'),
                              )
                            else
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => setState(() => _editing = false),
                                    child: const Text('Hủy'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      svc.updateBuildingConfig(
                                        name: _nameCtrl.text,
                                        address: _addrCtrl.text,
                                        open: _openCtrl.text,
                                        close: _closeCtrl.text,
                                      );
                                      setState(() => _editing = false);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Đã lưu cấu hình!')),
                                      );
                                    },
                                    child: const Text('Lưu'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_editing) ...[
                          TextField(
                            controller: _nameCtrl,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(labelText: 'Tên tòa nhà'),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _addrCtrl,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(labelText: 'Địa chỉ'),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _openCtrl,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: const InputDecoration(labelText: 'Giờ mở cửa', hintText: '06:00'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _closeCtrl,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: const InputDecoration(labelText: 'Giờ đóng cửa', hintText: '22:00'),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          _ConfigRow(Icons.business, 'Tên tòa nhà', svc.buildingName),
                          _ConfigRow(Icons.location_on, 'Địa chỉ', svc.buildingAddress),
                          _ConfigRow(Icons.access_time, 'Giờ hoạt động', '${svc.openTime} – ${svc.closeTime}'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _SystemStatCard(
                        icon: Icons.grid_view,
                        label: 'Tổng slot',
                        value: '$totalSlots',
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      _SystemStatCard(
                        icon: Icons.layers,
                        label: 'Số tầng',
                        value: '${svc.floors.length}',
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: 12),
                      _SystemStatCard(
                        icon: Icons.people,
                        label: 'Tài khoản',
                        value: '${svc.users.length}',
                        color: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 28),

            // Floor configuration
            Text('Cấu hình tầng & Loại xe', style: Theme.of(context).textTheme.titleLarge)
                .animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 14),
            Table(
              border: TableBorder.all(color: AppColors.border, borderRadius: BorderRadius.circular(12)),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: AppColors.surfaceLight),
                  children: [
                    _TH('Tầng'),
                    _TH('Loại xe'),
                    _TH('Tổng slot'),
                    _TH('Trống'),
                  ],
                ),
                ...svc.floors.map((floor) {
                  final slots = svc.slotsForFloor(floor.id);
                  final avail = svc.availableCount(floor.id);
                  return TableRow(
                    children: [
                      _TD(floor.name),
                      _TD(floor.capacityByType.keys.map((t) => '${t.icon} ${t.label}').join(', ')),
                      _TD('${slots.length}'),
                      _TDColor('$avail', avail > 0 ? AppColors.available : AppColors.occupied),
                    ],
                  );
                }),
              ],
            ).animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ConfigRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13),
                textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _SystemStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _SystemStatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _TD extends StatelessWidget {
  final String text;
  const _TD(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
    );
  }
}

class _TDColor extends StatelessWidget {
  final String text;
  final Color color;
  const _TDColor(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
