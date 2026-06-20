enum VehicleType { motorbike, car, truck }

extension VehicleTypeExt on VehicleType {
  String get label {
    switch (this) {
      case VehicleType.motorbike:
        return 'Xe máy';
      case VehicleType.car:
        return 'Ô tô';
      case VehicleType.truck:
        return 'Xe tải';
    }
  }

  String get icon {
    switch (this) {
      case VehicleType.motorbike:
        return '🏍️';
      case VehicleType.car:
        return '🚗';
      case VehicleType.truck:
        return '🚛';
    }
  }
}

class Vehicle {
  final String id;
  final String licensePlate;
  final VehicleType type;
  final String? ownerName;
  final String? ownerPhone;

  Vehicle({
    required this.id,
    required this.licensePlate,
    required this.type,
    this.ownerName,
    this.ownerPhone,
  });
}
