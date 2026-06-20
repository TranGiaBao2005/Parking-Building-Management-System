import 'vehicle.dart';

enum SessionStatus {
  active,
  completed,
  exception,
}

enum ExceptionType {
  none,
  lostTicket,
  wrongPlate,
  overtime,
  unpaid,
  wrongZone,
}

extension ExceptionTypeExt on ExceptionType {
  String get label {
    switch (this) {
      case ExceptionType.none:
        return 'Không';
      case ExceptionType.lostTicket:
        return 'Mất vé';
      case ExceptionType.wrongPlate:
        return 'Sai biển số';
      case ExceptionType.overtime:
        return 'Quá giờ';
      case ExceptionType.unpaid:
        return 'Chưa thanh toán';
      case ExceptionType.wrongZone:
        return 'Sai khu vực';
    }
  }
}

class ParkingSession {
  final String id;
  final String licensePlate;
  final VehicleType vehicleType;
  final String floorId;
  final String slotId;
  final String slotCode;
  final DateTime entryTime;
  DateTime? exitTime;
  double? totalFee;
  SessionStatus status;
  ExceptionType exceptionType;
  String? exceptionNote;
  String? staffId;
  bool isPaid;

  ParkingSession({
    required this.id,
    required this.licensePlate,
    required this.vehicleType,
    required this.floorId,
    required this.slotId,
    required this.slotCode,
    required this.entryTime,
    this.exitTime,
    this.totalFee,
    this.status = SessionStatus.active,
    this.exceptionType = ExceptionType.none,
    this.exceptionNote,
    this.staffId,
    this.isPaid = false,
  });

  Duration get duration {
    final end = exitTime ?? DateTime.now();
    return end.difference(entryTime);
  }

  double calculateFee(double ratePerHour) {
    final hours = duration.inMinutes / 60.0;
    return (hours * ratePerHour).ceilToDouble();
  }
}
