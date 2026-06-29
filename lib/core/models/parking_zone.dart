import 'vehicle.dart';

enum ParkingManagementStyle { rowBased, slotBased }

extension ParkingManagementStyleExt on ParkingManagementStyle {
  String get label {
    switch (this) {
      case ParkingManagementStyle.rowBased:
        return 'Theo dãy';
      case ParkingManagementStyle.slotBased:
        return 'Theo slot';
    }
  }
}

enum FlexibleZoneStatus {
  stable,
  watchingDemand,
  pendingRelease,
  readyToSwitch
}

extension FlexibleZoneStatusExt on FlexibleZoneStatus {
  String get label {
    switch (this) {
      case FlexibleZoneStatus.stable:
        return 'Ổn định';
      case FlexibleZoneStatus.watchingDemand:
        return 'Theo dõi nhu cầu';
      case FlexibleZoneStatus.pendingRelease:
        return 'Chờ giải phóng xe';
      case FlexibleZoneStatus.readyToSwitch:
        return 'Sẵn sàng chuyển mode';
    }
  }

  String get helperText {
    switch (this) {
      case FlexibleZoneStatus.stable:
        return 'Khu đang chạy đúng chế độ mặc định.';
      case FlexibleZoneStatus.watchingDemand:
        return 'AI đang theo dõi để quyết định có đổi mode hay không.';
      case FlexibleZoneStatus.pendingRelease:
        return 'Chỉ nhận xe mới theo mode hiện tại cho đến khi khu trống dần.';
      case FlexibleZoneStatus.readyToSwitch:
        return 'Có thể bật cấu hình mới cho xe vào sau mà không đụng xe đang đỗ.';
    }
  }
}

class ParkingZoneRow {
  final String id;
  final String label;
  final ParkingManagementStyle style;
  final VehicleType vehicleType;
  final int capacity;
  final int occupied;
  final List<String> slotCodes;
  final List<String> reservedSlotCodes;
  final String note;

  const ParkingZoneRow({
    required this.id,
    required this.label,
    required this.style,
    required this.vehicleType,
    required this.capacity,
    required this.occupied,
    this.slotCodes = const [],
    this.reservedSlotCodes = const [],
    this.note = '',
  });

  int get available => capacity - occupied;
}

class ParkingZoneLayout {
  final VehicleType vehicleType;
  final ParkingManagementStyle managementStyle;
  final String title;
  final String summary;
  final List<ParkingZoneRow> rows;

  const ParkingZoneLayout({
    required this.vehicleType,
    required this.managementStyle,
    required this.title,
    required this.summary,
    required this.rows,
  });

  int get capacity => rows.fold(0, (sum, row) => sum + row.capacity);

  int get occupied => rows.fold(0, (sum, row) => sum + row.occupied);

  int get available => capacity - occupied;
}

class ParkingZone {
  final String id;
  final String floorId;
  final String code;
  final String name;
  final String overview;
  final bool isFlexible;
  final VehicleType defaultMode;
  VehicleType currentMode;
  FlexibleZoneStatus status;
  final List<ParkingZoneLayout> layouts;

  ParkingZone({
    required this.id,
    required this.floorId,
    required this.code,
    required this.name,
    required this.overview,
    required this.isFlexible,
    required this.defaultMode,
    required this.currentMode,
    required this.status,
    required this.layouts,
  });

  ParkingZoneLayout get activeLayout => layoutFor(currentMode) ?? layouts.first;

  ParkingZoneLayout? layoutFor(VehicleType type) {
    for (final layout in layouts) {
      if (layout.vehicleType == type) return layout;
    }
    return null;
  }

  List<ParkingZoneLayout> get alternativeLayouts =>
      layouts.where((layout) => layout.vehicleType != currentMode).toList();
}

class FlexibleZoneSuggestion {
  final String id;
  final String zoneId;
  final String zoneCode;
  final String title;
  final String reason;
  final String impact;
  final String safeRule;
  final VehicleType currentMode;
  final VehicleType targetMode;
  final FlexibleZoneStatus status;

  const FlexibleZoneSuggestion({
    required this.id,
    required this.zoneId,
    required this.zoneCode,
    required this.title,
    required this.reason,
    required this.impact,
    required this.safeRule,
    required this.currentMode,
    required this.targetMode,
    required this.status,
  });
}
