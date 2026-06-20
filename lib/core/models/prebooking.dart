import 'vehicle.dart';

enum PrebookingStatus { pending, confirmed, cancelled, used }

class Prebooking {
  final String id;
  final String userId;
  final String userFullName;
  final VehicleType vehicleType;
  final String licensePlate;
  final String floorId;
  final DateTime bookingTime;
  final DateTime expectedEntry;
  final DateTime expectedExit;
  PrebookingStatus status;
  String? assignedSlotId;
  String? assignedSlotCode;
  String? confirmationCode;

  Prebooking({
    required this.id,
    required this.userId,
    required this.userFullName,
    required this.vehicleType,
    required this.licensePlate,
    required this.floorId,
    required this.bookingTime,
    required this.expectedEntry,
    required this.expectedExit,
    this.status = PrebookingStatus.pending,
    this.assignedSlotId,
    this.assignedSlotCode,
    this.confirmationCode,
  });
}
