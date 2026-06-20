import 'package:uuid/uuid.dart';
import 'vehicle.dart';

class AiRecommendation {
  final String id;
  final String title;
  final String description;
  final String impact;
  final VehicleType fromType;
  final VehicleType toType;
  final int slotsToConvert;
  final String targetFloorId;
  final List<String> targetSlotIds;

  AiRecommendation({
    String? id,
    required this.title,
    required this.description,
    required this.impact,
    required this.fromType,
    required this.toType,
    required this.slotsToConvert,
    required this.targetFloorId,
    required this.targetSlotIds,
  }) : id = id ?? const Uuid().v4();
}
