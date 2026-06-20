import 'vehicle.dart';

class ParkingFloor {
  final String id;
  final String name;
  final int floorNumber;
  final Map<VehicleType, int> capacityByType;

  ParkingFloor({
    required this.id,
    required this.name,
    required this.floorNumber,
    required this.capacityByType,
  });

  int get totalCapacity =>
      capacityByType.values.fold(0, (sum, v) => sum + v);
}
