import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import 'widgets/ai_optimization_dialog.dart';
import '../../shared/utils/responsive.dart';

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({super.key});

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  String _selectedFloorId = 'f1';
  SlotStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (isMobile) ...[
              Center(
                child: Text(
                  'Quản lý Slot',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 22),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _buildAiButton(context, svc)),
                  const SizedBox(width: 10),
                  _buildAvailableBadge(svc),
                ],
              ),
            ] else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Quản lý Slot',
                      style: Theme.of(context).textTheme.displayMedium),
                  Row(
                    children: [
                      _buildAiButton(context, svc),
                      const SizedBox(width: 12),
                      _buildAvailableBadge(svc),
                    ],
                  ),
                ],
              ).animate().fadeIn(),
            const SizedBox(height: 20),

            // Floor tabs
            _FloorTabs(
              floors: svc.floors,
              selectedId: _selectedFloorId,
              onSelect: (id) => setState(() => _selectedFloorId = id),
              svc: svc,
            ),
            const SizedBox(height: 16),

            // Filter row
            _FilterRow(
              selected: _filterStatus,
              onSelect: (s) => setState(() => _filterStatus = s),
            ),
            const SizedBox(height: 14),

            // Legend sits directly above the parking-slot grid.
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildLegend(),
              ),
            ),
            const SizedBox(height: 12),

            // Slot grid
            Expanded(
              child: _SlotGrid(
                svc: svc,
                floorId: _selectedFloorId,
                filterStatus: _filterStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiButton(BuildContext context, MockDataService svc) {
    return ElevatedButton.icon(
      onPressed: () {
        final recs = svc.generateAiOptimization();
        showDialog(
          context: context,
          builder: (_) => AiOptimizationDialog(recommendations: recs, svc: svc),
        );
      },
      icon: const Icon(Icons.auto_awesome, size: 18),
      label: const Text('Tối ưu bằng AI'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.5),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildLegend() {
    final items = [
      (AppColors.available, 'Trống'),
      (AppColors.occupied, 'Đang dùng'),
      (AppColors.reserved, 'Đặt trước'),
      (AppColors.maintenance, 'Bảo trì'),
      (AppColors.locked, 'Tạm khóa'),
    ];
    return Row(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: item.$1,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(item.$2,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAvailableBadge(MockDataService svc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.available.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.available.withOpacity(0.35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${svc.totalAvailable()}',
            style: const TextStyle(
              color: AppColors.available,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Ô trống',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

class _FloorTabs extends StatelessWidget {
  final List<ParkingFloor> floors;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final MockDataService svc;

  const _FloorTabs({
    required this.floors,
    required this.selectedId,
    required this.onSelect,
    required this.svc,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: floors.map((floor) {
          final isSelected = floor.id == selectedId;
          final avail = svc.availableCount(floor.id);
          final occ = svc.occupiedCount(floor.id);
          final total = svc.slotsForFloor(floor.id).length;
          return GestureDetector(
            onTap: () => onSelect(floor.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    floor.name,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trống: $avail | Dùng: $occ | Tổng: $total',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final SlotStatus? selected;
  final ValueChanged<SlotStatus?> onSelect;

  const _FilterRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final filters = [
      (null, 'Tất cả', AppColors.textSecondary),
      (SlotStatus.available, 'Trống', AppColors.available),
      (SlotStatus.occupied, 'Đang dùng', AppColors.occupied),
      (SlotStatus.reserved, 'Đặt trước', AppColors.reserved),
      (SlotStatus.maintenance, 'Bảo trì', AppColors.maintenance),
      (SlotStatus.locked, 'Tạm khóa', AppColors.locked),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isActive = selected == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.$2),
              selected: isActive,
              onSelected: (_) => onSelect(isActive ? null : f.$1),
              selectedColor: f.$3.withOpacity(0.2),
              checkmarkColor: f.$3,
              labelStyle: TextStyle(
                color: isActive ? f.$3 : AppColors.textSecondary,
                fontSize: 12,
              ),
              side: BorderSide(color: isActive ? f.$3 : AppColors.border),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SlotGrid extends StatelessWidget {
  final MockDataService svc;
  final String floorId;
  final SlotStatus? filterStatus;

  const _SlotGrid({
    required this.svc,
    required this.floorId,
    required this.filterStatus,
  });

  @override
  Widget build(BuildContext context) {
    var slotList = svc.slotsForFloor(floorId);
    if (filterStatus != null) {
      slotList = slotList.where((s) => s.status == filterStatus).toList();
    }

    if (slotList.isEmpty) {
      return const Center(
        child: Text('Không có slot nào.',
            style: TextStyle(color: AppColors.textMuted)),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 110,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: slotList.length,
      itemBuilder: (context, i) {
        final slot = slotList[i];
        return _SlotTile(
          slot: slot,
          onTap: () => _showSlotDialog(context, svc, slot),
        );
      },
    );
  }

  void _showSlotDialog(
      BuildContext context, MockDataService svc, ParkingSlot slot) {
    showDialog(
      context: context,
      builder: (ctx) => _SlotDetailDialog(slot: slot, svc: svc),
    );
  }
}

class _SlotTile extends StatefulWidget {
  final ParkingSlot slot;
  final VoidCallback onTap;
  const _SlotTile({required this.slot, required this.onTap});

  @override
  State<_SlotTile> createState() => _SlotTileState();
}

class _SlotTileState extends State<_SlotTile> {
  bool _hovered = false;

  Color get _color {
    switch (widget.slot.status) {
      case SlotStatus.available:
        return AppColors.available;
      case SlotStatus.occupied:
        return AppColors.occupied;
      case SlotStatus.reserved:
        return AppColors.reserved;
      case SlotStatus.maintenance:
        return AppColors.maintenance;
      case SlotStatus.locked:
        return AppColors.locked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _color.withOpacity(_hovered ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _color.withOpacity(_hovered ? 0.8 : 0.4),
              width: _hovered ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.slot.allowedType.icon,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                widget.slot.slotCode,
                style: TextStyle(
                  color: _color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlotDetailDialog extends StatefulWidget {
  final ParkingSlot slot;
  final MockDataService svc;
  const _SlotDetailDialog({required this.slot, required this.svc});

  @override
  State<_SlotDetailDialog> createState() => _SlotDetailDialogState();
}

class _SlotDetailDialogState extends State<_SlotDetailDialog> {
  late SlotStatus _newStatus;

  @override
  void initState() {
    super.initState();
    _newStatus = widget.slot.status;
  }

  @override
  Widget build(BuildContext context) {
    final canChange = widget.slot.status != SlotStatus.occupied;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Slot ${widget.slot.slotCode}',
          style: const TextStyle(color: AppColors.textPrimary)),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Loại xe', widget.slot.allowedType.label),
            _InfoRow('Tầng', widget.slot.floorId),
            _InfoRow('Trạng thái hiện tại', widget.slot.status.label),
            if (widget.slot.currentLicensePlate != null)
              _InfoRow('Biển số', widget.slot.currentLicensePlate!),
            if (canChange) ...[
              const SizedBox(height: 16),
              const Text('Đổi trạng thái:',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              DropdownButtonFormField<SlotStatus>(
                value: _newStatus,
                dropdownColor: AppColors.surfaceLight,
                style: const TextStyle(color: AppColors.textPrimary),
                items: [
                  SlotStatus.available,
                  SlotStatus.maintenance,
                  SlotStatus.locked,
                ]
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.label),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _newStatus = v!),
                decoration: const InputDecoration(isDense: true),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
        if (canChange)
          ElevatedButton(
            onPressed: () {
              widget.svc.updateSlotStatus(widget.slot.id, _newStatus);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Đã cập nhật slot ${widget.slot.slotCode}')),
              );
            },
            child: const Text('Cập nhật'),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
