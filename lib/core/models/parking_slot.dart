import 'vehicle.dart';

enum SlotStatus { available, occupied, reserved, maintenance, locked }

extension SlotStatusExt on SlotStatus {
  String get label {
    switch (this) {
      case SlotStatus.available:
        return 'Trống';
      case SlotStatus.occupied:
        return 'Đang dùng';
      case SlotStatus.reserved:
        return 'Đặt trước';
      case SlotStatus.maintenance:
        return 'Bảo trì';
      case SlotStatus.locked:
        return 'Tạm khóa';
    }
  }
}

class ParkingSlot {
  final String id;
  final String floorId;
  final String slotCode;
  SlotStatus status;
  VehicleType allowedType;
  String? currentSessionId;
  String? currentLicensePlate;

  ParkingSlot({
    required this.id,
    required this.floorId,
    required this.slotCode,
    required this.allowedType,
    this.status = SlotStatus.available,
    this.currentSessionId,
    this.currentLicensePlate,
  });

  ParkingSlot copyWith({
    SlotStatus? status,
    String? currentSessionId,
    String? currentLicensePlate,
  }) {
    return ParkingSlot(
      id: id,
      floorId: floorId,
      slotCode: slotCode,
      allowedType: allowedType,
      status: status ?? this.status,
      currentSessionId: currentSessionId ?? this.currentSessionId,
      currentLicensePlate: currentLicensePlate ?? this.currentLicensePlate,
    );
  }
}
