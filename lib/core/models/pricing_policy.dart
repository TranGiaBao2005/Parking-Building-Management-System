import 'vehicle.dart';

class PricingPolicy {
  final String id;
  VehicleType vehicleType;
  double ratePerHour;
  double? overnightRate;
  double? monthlyRate;
  String? description;

  PricingPolicy({
    required this.id,
    required this.vehicleType,
    required this.ratePerHour,
    this.overnightRate,
    this.monthlyRate,
    this.description,
  });
}
