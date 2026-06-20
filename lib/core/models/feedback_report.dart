import 'vehicle.dart';

enum FeedbackCategory { lostTicket, wrongFee, occupiedSlot, other }

extension FeedbackCategoryExt on FeedbackCategory {
  String get label {
    switch (this) {
      case FeedbackCategory.lostTicket:
        return 'Mất vé';
      case FeedbackCategory.wrongFee:
        return 'Phí sai';
      case FeedbackCategory.occupiedSlot:
        return 'Slot bị chiếm';
      case FeedbackCategory.other:
        return 'Khác';
    }
  }
}

enum FeedbackStatus { pending, resolved }

class FeedbackReport {
  final String id;
  final String userId;
  final String userFullName;
  final String? sessionId;
  final String? licensePlate;
  FeedbackCategory category;
  String description;
  FeedbackStatus status;
  String? resolution;
  final DateTime createdAt;
  DateTime? resolvedAt;

  FeedbackReport({
    required this.id,
    required this.userId,
    required this.userFullName,
    this.sessionId,
    this.licensePlate,
    required this.category,
    required this.description,
    this.status = FeedbackStatus.pending,
    this.resolution,
    required this.createdAt,
    this.resolvedAt,
  });
}
