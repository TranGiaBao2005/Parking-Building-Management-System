import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/models/models.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/theme/app_theme.dart';

class AiOptimizationDialog extends StatelessWidget {
  final List<FlexibleZoneSuggestion> suggestions;
  final MockDataService svc;

  const AiOptimizationDialog({
    super.key,
    required this.suggestions,
    required this.svc,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 620,
        constraints: const BoxConstraints(maxHeight: 760),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withOpacity(0.28)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.16),
              blurRadius: 36,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: const Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gợi ý AI cho khu sắp xếp',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'AI theo dõi lượng xe để gợi ý chuyển khu theo loại xe khi cần.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Flexible(
              child: suggestions.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Chưa có gợi ý nào cho tầng này.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        final zone = svc.parkingZones
                            .where((item) => item.id == suggestion.zoneId)
                            .firstOrNull;

                        return _SuggestionCard(
                          suggestion: suggestion,
                          zone: zone,
                          onApply: () {
                            svc.previewFlexibleZoneMode(
                              zoneId: suggestion.zoneId,
                              targetMode: suggestion.targetMode,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã chuyển khu ${suggestion.zoneCode} sang ${suggestion.targetMode.label}.',
                                ),
                              ),
                            );
                          },
                          onReset: () {
                            svc.resetFlexibleZoneMode(suggestion.zoneId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã trả khu ${suggestion.zoneCode} về cách sử dụng ban đầu.',
                                ),
                              ),
                            );
                          },
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 100 * index),
                            )
                            .slideY(begin: 0.08);
                      },
                    ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.97, 0.97));
  }
}

class _SuggestionCard extends StatelessWidget {
  final FlexibleZoneSuggestion suggestion;
  final ParkingZone? zone;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const _SuggestionCard({
    required this.suggestion,
    required this.zone,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final activeVehicle = zone?.currentMode ?? suggestion.currentMode;
    final isApplied = activeVehicle == suggestion.targetMode;
    final statusColor = _statusColor(suggestion.status);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _Chip(
                  label: 'Khu ${suggestion.zoneCode}',
                  color: AppColors.primary,
                ),
                _Chip(
                  label: 'Đang dùng cho: ${activeVehicle.label}',
                  color: _vehicleColor(activeVehicle),
                ),
                _Chip(
                  label: _statusText(suggestion.status),
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              _displayTitle(suggestion),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.reason,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            _InfoTile(
              icon: Icons.swap_horiz_rounded,
              label: 'Kết quả mong muốn',
              text: suggestion.impact,
            ),
            const SizedBox(height: 10),
            _InfoTile(
              icon: Icons.shield_outlined,
              label: 'Lưu ý khi chuyển khu',
              text: _displaySafeRule(suggestion),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: isApplied ? onReset : null,
                  child: const Text('Trả về ban đầu'),
                ),
                ElevatedButton.icon(
                  onPressed: isApplied ? null : onApply,
                  icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                  label: Text(isApplied ? 'Đang áp dụng' : 'Chuyển khu này'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(FlexibleZoneStatus status) {
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

  String _displayTitle(FlexibleZoneSuggestion suggestion) {
    if (suggestion.zoneId == 'zone-b') {
      return 'Nếu xe hơi tăng, đổi khu B sang khu xe hơi';
    }
    if (suggestion.zoneId == 'zone-d') {
      return 'Nếu xe máy tăng mạnh, đổi khu D sang khu xe máy';
    }
    return suggestion.title;
  }

  String _displaySafeRule(FlexibleZoneSuggestion suggestion) {
    if (suggestion.zoneId == 'zone-b') {
      return 'Chỉ dừng nhận xe máy mới ở khu B, chờ xe đang có rời đi rồi mới chuyển hẳn sang khu xe hơi.';
    }
    if (suggestion.zoneId == 'zone-d') {
      return 'Không đổi các xe đang đậu. Chỉ ngừng nhận xe hơi mới ở khu D và chuyển sau khi khu đủ trống.';
    }
    return suggestion.safeRule;
  }

  Color _statusColor(FlexibleZoneStatus status) {
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

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withOpacity(0.38),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
