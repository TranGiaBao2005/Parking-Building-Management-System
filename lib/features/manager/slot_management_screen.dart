import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/utils/responsive.dart';
import 'widgets/ai_optimization_dialog.dart';

enum ParkingViewMode { byZone, bySlot }

extension ParkingViewModeExt on ParkingViewMode {
  String get label => this == ParkingViewMode.byZone ? 'Theo khu' : 'Theo ô';
}

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({super.key});

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  String _selectedFloorId = 'f1';
  SlotStatus? _filterStatus;
  ParkingViewMode _viewMode = ParkingViewMode.byZone;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final isMobile = Responsive.isMobile(context);
    final suggestions = svc.flexibleZoneSuggestionsForFloor(_selectedFloorId);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              isMobile: isMobile,
              viewMode: _viewMode,
              totalAvailable: svc.totalAvailable(),
              onOpenAi: suggestions.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (_) => AiOptimizationDialog(
                          suggestions: suggestions,
                          svc: svc,
                        ),
                      );
                    },
            ),
            const SizedBox(height: 20),
            _FloorTabs(
              floors: svc.floors,
              selectedId: _selectedFloorId,
              onSelect: (id) => setState(() => _selectedFloorId = id),
              svc: svc,
            ),
            const SizedBox(height: 16),
            _ViewSwitcher(
              selected: _viewMode,
              onChanged: (mode) => setState(() => _viewMode = mode),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: _viewMode == ParkingViewMode.byZone
                    ? _ZoneView(
                        key: ValueKey('zone-$_selectedFloorId'),
                        floorId: _selectedFloorId,
                      )
                    : _SlotView(
                        key: ValueKey(
                          'slot-$_selectedFloorId-${_filterStatus?.name ?? 'all'}',
                        ),
                        floorId: _selectedFloorId,
                        filterStatus: _filterStatus,
                        onFilterChanged: (status) {
                          setState(() => _filterStatus = status);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isMobile;
  final ParkingViewMode viewMode;
  final int totalAvailable;
  final VoidCallback? onOpenAi;

  const _Header({
    required this.isMobile,
    required this.viewMode,
    required this.totalAvailable,
    required this.onOpenAi,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = viewMode == ParkingViewMode.byZone
        ? 'Theo dõi bãi xe theo khu, dãy và ô của từng loại xe.'
        : 'Theo dõi từng ô đỗ cụ thể trên từng tầng.';

    final titleBlock = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Quản lý bãi đỗ',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isMobile ? 22 : null,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: onOpenAi,
          icon: const Icon(Icons.auto_awesome_rounded, size: 18),
          label: const Text('Gợi ý AI'),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.slotAvailable.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.slotAvailable.withOpacity(0.35),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$totalAvailable',
                style: const TextStyle(
                  color: AppColors.slotAvailable,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Ô trống',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleBlock,
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: actions),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        actions,
      ],
    ).animate().fadeIn();
  }
}

class _ViewSwitcher extends StatelessWidget {
  final ParkingViewMode selected;
  final ValueChanged<ParkingViewMode> onChanged;

  const _ViewSwitcher({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ParkingViewMode.values.map((mode) {
          final isActive = selected == mode;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(mode.label),
              selected: isActive,
              onSelected: (_) => onChanged(mode),
              selectedColor: AppColors.primary.withOpacity(0.18),
              side: BorderSide(
                color: isActive ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ZoneView extends StatelessWidget {
  final String floorId;

  const _ZoneView({super.key, required this.floorId});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final zones = svc.zonesForFloor(floorId);
    final groups = _buildVehicleGroups(svc, zones);
    final suggestions = svc.flexibleZoneSuggestionsForFloor(floorId);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ZoneStatsRow(
            totalRows: groups.fold(0, (sum, group) => sum + group.rows.length),
            aiRows: groups
                .where((group) => group.hasAi)
                .fold(0, (sum, group) => sum + group.rows.length),
            activeCapacity: svc.zoneCapacityForFloor(floorId),
            activeOccupied: svc.zoneOccupiedForFloor(floorId),
            rowBasedCapacity: svc.rowBasedCapacityForFloor(floorId),
            slotBasedCapacity: svc.slotBasedCapacityForFloor(floorId),
          ),
          const SizedBox(height: 18),
          ...groups.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == groups.length - 1 ? 0 : 16,
              ),
              child: _VehicleGroupCard(group: entry.value),
            );
          }),
        ],
      ),
    );
  }

  List<_VehicleGroupData> _buildVehicleGroups(
    MockDataService svc,
    List<ParkingZone> zones,
  ) {
    final grouped = <VehicleType, List<ParkingZone>>{};

    for (final zone in zones) {
      final type = zone.activeLayout.vehicleType;
      grouped.putIfAbsent(type, () => []).add(zone);
    }

    const order = [
      VehicleType.motorbike,
      VehicleType.car,
      VehicleType.truck,
    ];

    return order.where(grouped.containsKey).map((type) {
      final bucket = grouped[type]!;
      final rows = bucket.expand((zone) => zone.activeLayout.rows).toList()
        ..sort((a, b) => a.label.compareTo(b.label));
      final aiZones = bucket.where((zone) => zone.isFlexible).toList();
      final aiChanged = aiZones.any(
        (zone) => zone.currentMode != zone.defaultMode,
      );
      final floorId = bucket.first.floorId;
      final bookedCount = svc
          .slotsForFloor(floorId)
          .where(
            (slot) =>
                slot.allowedType == type && slot.status == SlotStatus.reserved,
          )
          .length;

      return _VehicleGroupData(
        vehicleType: type,
        rows: rows,
        hasAi: aiZones.isNotEmpty,
        aiChanged: aiChanged,
        bookedCount: bookedCount,
        status: aiZones.isNotEmpty
            ? (aiChanged
                ? FlexibleZoneStatus.readyToSwitch
                : aiZones.first.status)
            : FlexibleZoneStatus.stable,
      );
    }).toList();
  }

  String _displayFloorName(ParkingFloor floor) {
    switch (floor.id) {
      case 'f1':
        return 'Tầng 1 (Xe máy)';
      case 'f2':
        return 'Tầng 2 (Xe máy + xe hơi)';
      case 'f3':
        return 'Tầng 3 (Xe hơi)';
      case 'f4':
        return 'Tầng 4 (Xe hơi + xe tải)';
      default:
        return floor.name;
    }
  }
}

class _ZoneSummaryCard extends StatelessWidget {
  final int zoneCount;
  final int aiCount;

  const _ZoneSummaryCard({
    required this.zoneCount,
    required this.aiCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.18),
            AppColors.accent.withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(
                icon: Icons.map_outlined,
                text: '$zoneCount khu đang hoạt động',
                color: AppColors.accent,
              ),
              _InfoChip(
                icon: Icons.auto_awesome_rounded,
                text: '$aiCount khu do AI sắp xếp',
                color: AppColors.aiManaged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ZoneStatsRow extends StatelessWidget {
  final int totalRows;
  final int aiRows;
  final int activeCapacity;
  final int activeOccupied;
  final int rowBasedCapacity;
  final int slotBasedCapacity;

  const _ZoneStatsRow({
    required this.totalRows,
    required this.aiRows,
    required this.activeCapacity,
    required this.activeOccupied,
    required this.rowBasedCapacity,
    required this.slotBasedCapacity,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _ZoneStatData(
        label: 'Tổng dãy xe',
        value: '$totalRows',
        helper: 'Tổng số dãy đang có',
        color: AppColors.primary,
      ),
      _ZoneStatData(
        label: 'Dãy AI sắp xếp',
        value: '$aiRows',
        helper: 'Số dãy AI đang điều phối',
        color: AppColors.aiManaged,
      ),
      _ZoneStatData(
        label: 'Sức chứa đang dùng',
        value: '$activeOccupied / $activeCapacity',
        helper: 'Tổng số chỗ đang dùng',
        color: AppColors.occupied,
      ),
      _ZoneStatData(
        label: 'Chỗ xe máy',
        value: '$rowBasedCapacity',
        helper: 'Sức chứa xe máy',
        color: AppColors.reserved,
      ),
      _ZoneStatData(
        label: 'Chỗ xe hơi / tải',
        value: '$slotBasedCapacity',
        helper: 'Sức chứa theo ô',
        color: AppColors.primaryLight,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        final columns = isMobile ? 2 : 5;
        final spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (item) => SizedBox(
                  width: width,
                  child: _ZoneStatCard(data: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ZoneStatData {
  final String label;
  final String value;
  final String helper;
  final Color color;

  const _ZoneStatData({
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });
}

class _ZoneStatCard extends StatelessWidget {
  final _ZoneStatData data;

  const _ZoneStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.value,
            style: TextStyle(
              color: data.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.helper,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleGroupData {
  final VehicleType vehicleType;
  final List<ParkingZoneRow> rows;
  final bool hasAi;
  final bool aiChanged;
  final int bookedCount;
  final FlexibleZoneStatus status;

  const _VehicleGroupData({
    required this.vehicleType,
    required this.rows,
    required this.hasAi,
    required this.aiChanged,
    required this.bookedCount,
    required this.status,
  });

  int get capacity => rows.fold(0, (sum, row) => sum + row.capacity);

  int get occupied => rows.fold(0, (sum, row) => sum + row.occupied);

  ParkingManagementStyle get style =>
      rows.isEmpty ? ParkingManagementStyle.slotBased : rows.first.style;

  ParkingZoneLayout get mergedLayout => ParkingZoneLayout(
        vehicleType: vehicleType,
        managementStyle: style,
        title: _vehicleTitle(vehicleType),
        summary: '',
        rows: rows,
      );

  static String _vehicleTitle(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return 'Xe máy';
      case VehicleType.car:
        return 'Xe hơi';
      case VehicleType.truck:
        return 'Xe tải';
    }
  }
}

class _VehicleGroupCard extends StatelessWidget {
  final _VehicleGroupData group;

  const _VehicleGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final color = _vehicleColor(group.vehicleType);
    final rate = group.capacity == 0 ? 0.0 : group.occupied / group.capacity;
    final hasBooking = group.bookedCount > 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: group.aiChanged
            ? AppColors.aiManaged.withOpacity(0.08)
            : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: group.aiChanged
              ? AppColors.aiManaged.withOpacity(0.5)
              : AppColors.available.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoChip(
                icon: Icons.directions_car_filled_rounded,
                text: _vehicleTitle(group.vehicleType),
                color: color,
              ),
              if (hasBooking)
                _InfoChip(
                  icon: Icons.bookmark_added_rounded,
                  text: 'Đã book',
                  color: AppColors.reserved,
                ),
              if (group.hasAi)
                _InfoChip(
                  icon: Icons.auto_awesome_rounded,
                  text: group.aiChanged ? 'AI đã đổi khu' : 'AI đang theo dõi',
                  color:
                      group.aiChanged ? AppColors.aiManaged : AppColors.accent,
                ),
              if (!group.hasAi)
                _InfoChip(
                  icon: Icons.circle,
                  text: _zoneStatusText(group.status),
                  color: _zoneStatusColor(group.status),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _vehicleTitle(group.vehicleType),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.28),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoChip(
                      icon: Icons.local_parking_outlined,
                      text: '${group.occupied}/${group.capacity} chỗ',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: rate,
                    minHeight: 8,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _UsageSection(
            title: 'Dãy',
            layout: group.mergedLayout,
            color: color,
          ),
        ],
      ),
    );
  }

  String _vehicleTitle(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return 'Xe máy';
      case VehicleType.car:
        return 'Xe hơi';
      case VehicleType.truck:
        return 'Xe tải';
    }
  }

  String _zoneStatusText(FlexibleZoneStatus status) {
    switch (status) {
      case FlexibleZoneStatus.stable:
        return 'Đang hoạt động';
      case FlexibleZoneStatus.watchingDemand:
        return 'AI đang theo dõi';
      case FlexibleZoneStatus.pendingRelease:
        return 'Chờ trống thêm';
      case FlexibleZoneStatus.readyToSwitch:
        return 'AI đã đổi khu';
    }
  }

  Color _zoneStatusColor(FlexibleZoneStatus status) {
    switch (status) {
      case FlexibleZoneStatus.stable:
        return AppColors.available;
      case FlexibleZoneStatus.watchingDemand:
        return AppColors.accent;
      case FlexibleZoneStatus.pendingRelease:
        return AppColors.reserved;
      case FlexibleZoneStatus.readyToSwitch:
        return AppColors.aiManaged;
    }
  }

  Color _vehicleColor(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return AppColors.available;
      case VehicleType.car:
        return AppColors.primaryLight;
      case VehicleType.truck:
        return AppColors.reserved;
    }
  }
}

class _ZoneCard extends StatelessWidget {
  final ParkingZone zone;

  const _ZoneCard({required this.zone});

  @override
  Widget build(BuildContext context) {
    final active = zone.activeLayout;
    final color = _vehicleColor(active.vehicleType);
    final rate = active.capacity == 0 ? 0.0 : active.occupied / active.capacity;
    final isAiChanged = zone.isFlexible && zone.currentMode != zone.defaultMode;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isAiChanged
            ? AppColors.aiManaged.withOpacity(0.08)
            : AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAiChanged
              ? AppColors.aiManaged.withOpacity(0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoChip(
                icon: Icons.place_outlined,
                text: 'Khu ${zone.code}',
                color: color,
              ),
              if (zone.isFlexible)
                _InfoChip(
                  icon: Icons.auto_awesome_rounded,
                  text: isAiChanged ? 'AI đã đổi khu' : 'AI đang theo dõi',
                  color: isAiChanged ? AppColors.aiManaged : AppColors.accent,
                ),
              _InfoChip(
                icon: Icons.circle,
                text: _zoneStatusText(zone.status),
                color: _zoneStatusColor(zone.status),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _zoneTitle(zone),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            _zoneOverview(zone),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight.withOpacity(0.28),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoChip(
                      icon: Icons.directions_car_filled_rounded,
                      text: active.vehicleType.label,
                      color: color,
                    ),
                    _InfoChip(
                      icon: active.managementStyle ==
                              ParkingManagementStyle.rowBased
                          ? Icons.segment
                          : Icons.grid_view_rounded,
                      text: active.managementStyle ==
                              ParkingManagementStyle.rowBased
                          ? 'Theo dãy'
                          : 'Theo ô',
                      color: AppColors.textSecondary,
                    ),
                    _InfoChip(
                      icon: Icons.local_parking_outlined,
                      text: '${active.occupied}/${active.capacity} chỗ',
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: rate,
                    minHeight: 8,
                    backgroundColor: AppColors.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                if (zone.isFlexible) ...[
                  const SizedBox(height: 12),
                  Text(
                    _flexibleHelp(zone.status),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _UsageSection(
            title: 'Đang sử dụng hiện tại',
            layout: active,
            color: color,
          ),
        ],
      ),
    );
  }

  String _zoneStatusText(FlexibleZoneStatus status) {
    switch (status) {
      case FlexibleZoneStatus.stable:
        return 'Đang hoạt động';
      case FlexibleZoneStatus.watchingDemand:
        return 'AI đang theo dõi';
      case FlexibleZoneStatus.pendingRelease:
        return 'Chờ trống thêm';
      case FlexibleZoneStatus.readyToSwitch:
        return 'AI đã đổi khu';
    }
  }

  Color _zoneStatusColor(FlexibleZoneStatus status) {
    switch (status) {
      case FlexibleZoneStatus.stable:
        return AppColors.available;
      case FlexibleZoneStatus.watchingDemand:
        return AppColors.accent;
      case FlexibleZoneStatus.pendingRelease:
        return AppColors.reserved;
      case FlexibleZoneStatus.readyToSwitch:
        return AppColors.aiManaged;
    }
  }

  Color _vehicleColor(VehicleType type) {
    switch (type) {
      case VehicleType.motorbike:
        return AppColors.available;
      case VehicleType.car:
        return AppColors.primaryLight;
      case VehicleType.truck:
        return AppColors.reserved;
    }
  }

  String _flexibleHelp(FlexibleZoneStatus status) {
    switch (status) {
      case FlexibleZoneStatus.stable:
        return 'Khu này đang hoạt động bình thường theo cách sắp xếp hiện tại.';
      case FlexibleZoneStatus.watchingDemand:
        return 'AI đang theo dõi lượng xe để quyết định có nên đổi khu này cho loại xe khác hay không.';
      case FlexibleZoneStatus.pendingRelease:
        return 'Khu này đang chờ bớt xe trước khi AI đổi sang loại xe khác.';
      case FlexibleZoneStatus.readyToSwitch:
        return 'Khu này đã được AI đổi sang cách sắp xếp mới cho xe vào sau.';
    }
  }

  String _zoneTitle(ParkingZone zone) {
    switch (zone.id) {
      case 'zone-a':
        return 'Xe máy';
      case 'zone-e':
        return 'Xe máy';
      case 'zone-b':
        return zone.currentMode == VehicleType.car
            ? 'AI sắp xếp cho xe hơi'
            : 'AI sắp xếp cho xe máy';
      case 'zone-c':
        return 'Xe hơi';
      case 'zone-f':
        return 'Xe hơi';
      case 'zone-t':
        return 'Xe tải';
      default:
        return zone.name;
    }
  }

  String _zoneOverview(ParkingZone zone) {
    switch (zone.id) {
      case 'zone-a':
        return 'Theo dõi theo từng dãy để dễ nhìn còn bao nhiêu chỗ.';
      case 'zone-e':
        return 'Hiển thị theo dãy để dễ xem còn bao nhiêu chỗ.';
      case 'zone-b':
        return zone.currentMode == VehicleType.car
            ? 'Khu này đang được AI chuyển sang xe hơi, nên sẽ hiện rõ từng dãy và từng ô đang dùng.'
            : 'Khu này đang được AI giữ cho xe máy để theo dõi theo dãy.';
      case 'zone-c':
        return 'Mỗi xe có ô riêng để dễ tìm xe.';
      case 'zone-f':
        return 'Hiển thị theo từng ô cụ thể.';
      case 'zone-t':
        return 'Xe tải cần ô riêng vì kích thước lớn.';
      default:
        return zone.overview;
    }
  }
}

class _UsageSection extends StatelessWidget {
  final String title;
  final ParkingZoneLayout layout;
  final Color color;
  final bool compact;

  const _UsageSection({
    required this.title,
    required this.layout,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.52),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: compact ? 14 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _InfoChip(
                icon: Icons.rule_folder_outlined,
                text: layout.vehicleType.label,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...layout.rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RowCard(row: row, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final ParkingZoneRow row;
  final Color color;

  const _RowCard({
    required this.row,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                row.label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${row.occupied}/${row.capacity}',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (row.style == ParkingManagementStyle.rowBased)
            _RowCapacityBar(row: row, color: color)
          else
            _SlotWrap(row: row),
        ],
      ),
    );
  }
}

class _RowCapacityBar extends StatelessWidget {
  final ParkingZoneRow row;
  final Color color;

  const _RowCapacityBar({
    required this.row,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(row.capacity, (index) {
        final occupied = index < row.occupied;
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: occupied ? color.withOpacity(0.72) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: occupied ? color : color.withOpacity(0.35),
            ),
          ),
        );
      }),
    );
  }
}

class _SlotWrap extends StatelessWidget {
  final ParkingZoneRow row;

  const _SlotWrap({
    required this.row,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: row.slotCodes.asMap().entries.map((entry) {
        final slotCode = entry.value;
        final reserved = row.reservedSlotCodes.contains(slotCode);
        final nonReservedBefore = row.slotCodes
            .take(entry.key)
            .where((code) => !row.reservedSlotCodes.contains(code))
            .length;
        final occupied = !reserved && nonReservedBefore < row.occupied;
        final fillColor = reserved
            ? AppColors.reserved
            : occupied
                ? AppColors.occupied
                : AppColors.slotAvailable;
        final bgColor = reserved
            ? AppColors.reserved.withOpacity(0.18)
            : occupied
                ? AppColors.occupied.withOpacity(0.16)
                : Colors.transparent;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: fillColor,
            ),
          ),
          child: Text(
            slotCode,
            style: TextStyle(
              color: fillColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotView extends StatelessWidget {
  final String floorId;
  final SlotStatus? filterStatus;
  final ValueChanged<SlotStatus?> onFilterChanged;

  const _SlotView({
    super.key,
    required this.floorId,
    required this.filterStatus,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterRow(
          selected: filterStatus,
          onSelect: onFilterChanged,
        ),
        const SizedBox(height: 14),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _Legend(),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _SlotGrid(
            svc: svc,
            floorId: floorId,
            filterStatus: filterStatus,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppColors.slotAvailable, 'Trống'),
      (AppColors.occupied, 'Đang dùng'),
      (AppColors.reserved, 'Đặt trước'),
      (AppColors.maintenance, 'Bảo trì'),
      (AppColors.locked, 'Tạm khóa'),
    ];

    return Row(
      children: items
          .map(
            (item) => Padding(
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
                  Text(
                    item.$2,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
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
          final floorTitle = _displayFloorName(floor);
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
                    floorTitle,
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
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _displayFloorName(ParkingFloor floor) {
    switch (floor.id) {
      case 'f1':
        return 'Tầng 1 (Xe máy)';
      case 'f2':
        return 'Tầng 2 (Xe máy + xe hơi)';
      case 'f3':
        return 'Tầng 3 (Xe hơi)';
      case 'f4':
        return 'Tầng 4 (Xe hơi + xe tải)';
      default:
        return floor.name;
    }
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
      (SlotStatus.available, 'Trống', AppColors.slotAvailable),
      (SlotStatus.occupied, 'Đang dùng', AppColors.occupied),
      (SlotStatus.reserved, 'Đặt trước', AppColors.reserved),
      (SlotStatus.maintenance, 'Bảo trì', AppColors.maintenance),
      (SlotStatus.locked, 'Tạm khóa', AppColors.locked),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((item) {
          final isActive = selected == item.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(item.$2),
              selected: isActive,
              onSelected: (_) => onSelect(isActive ? null : item.$1),
              selectedColor: item.$3.withOpacity(0.2),
              checkmarkColor: item.$3,
              side: BorderSide(color: isActive ? item.$3 : AppColors.border),
              labelStyle: TextStyle(
                color: isActive ? item.$3 : AppColors.textSecondary,
                fontSize: 12,
              ),
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
      slotList = slotList.where((slot) => slot.status == filterStatus).toList();
    }

    if (slotList.isEmpty) {
      return const Center(
        child: Text(
          'Không có ô nào.',
          style: TextStyle(color: AppColors.textMuted),
        ),
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
      itemBuilder: (context, index) {
        final slot = slotList[index];
        return _SlotTile(
          slot: slot,
          onTap: () => _showSlotDialog(context, svc, slot),
        );
      },
    );
  }

  void _showSlotDialog(
    BuildContext context,
    MockDataService svc,
    ParkingSlot slot,
  ) {
    showDialog(
      context: context,
      builder: (_) => _SlotDetailDialog(slot: slot, svc: svc),
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
        return AppColors.slotAvailable;
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

  const _SlotDetailDialog({
    required this.slot,
    required this.svc,
  });

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
      title: Text(
        'Ô ${widget.slot.slotCode}',
        style: const TextStyle(color: AppColors.textPrimary),
      ),
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
              const Text(
                'Đổi trạng thái:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
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
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _newStatus = value!),
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
                  content: Text('Đã cập nhật ô ${widget.slot.slotCode}'),
                ),
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
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
