import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class ExceptionScreen extends StatefulWidget {
  const ExceptionScreen({super.key});

  @override
  State<ExceptionScreen> createState() => _ExceptionScreenState();
}

class _ExceptionScreenState extends State<ExceptionScreen> {
  final dtFmt = DateFormat('HH:mm – dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final exceptions = svc.exceptionSessions;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Xử lý Ngoại lệ', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 4),
                    const Text('Giải quyết mất thẻ, sai biển số, xe quá giờ...',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.reserved.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.reserved.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${exceptions.length} trường hợp cần xử lý',
                    style: const TextStyle(color: AppColors.reserved, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ).animate().fadeIn(),
            const SizedBox(height: 28),

            // Exception type summary
            Row(
              children: ExceptionType.values
                  .where((e) => e != ExceptionType.none)
                  .map((t) {
                final count = exceptions.where((s) => s.exceptionType == t).length;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Text(t.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.occupied.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('$count',
                                style: const TextStyle(color: AppColors.occupied, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),

            // List
            Expanded(
              child: exceptions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, color: AppColors.available, size: 60),
                          SizedBox(height: 16),
                          Text('Không có ngoại lệ nào!',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: exceptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        return _ExceptionCard(
                          session: exceptions[i],
                          dtFmt: dtFmt,
                          onResolve: () => _showResolveDialog(context, svc, exceptions[i]),
                        ).animate().fadeIn(delay: Duration(milliseconds: 100 + i * 60));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context, MockDataService svc, ParkingSession session) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Xử lý: ${session.exceptionType.label}',
            style: const TextStyle(color: AppColors.textPrimary)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Xe: ${session.licensePlate}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 16),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Ghi chú xử lý',
                  hintText: 'Mô tả cách giải quyết...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              svc.resolveException(session.id, noteCtrl.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã xử lý ngoại lệ cho xe ${session.licensePlate}')),
              );
            },
            child: const Text('Xác nhận đã xử lý'),
          ),
        ],
      ),
    );
  }
}

class _ExceptionCard extends StatelessWidget {
  final ParkingSession session;
  final DateFormat dtFmt;
  final VoidCallback onResolve;
  const _ExceptionCard({required this.session, required this.dtFmt, required this.onResolve});

  Color get _typeColor {
    switch (session.exceptionType) {
      case ExceptionType.lostTicket:
        return AppColors.reserved;
      case ExceptionType.overtime:
        return AppColors.occupied;
      case ExceptionType.wrongPlate:
        return AppColors.locked;
      case ExceptionType.unpaid:
        return AppColors.occupied;
      case ExceptionType.wrongZone:
        return AppColors.maintenance;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dur = DateTime.now().difference(session.entryTime);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _typeColor.withOpacity(0.4), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _typeColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.warning_amber, color: _typeColor, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _typeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        session.exceptionType.label,
                        style: TextStyle(color: _typeColor, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${dur.inHours}g${dur.inMinutes % 60}m',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  session.licensePlate,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.vehicleType.icon} ${session.vehicleType.label}  •  Slot ${session.slotCode}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vào: ${dtFmt.format(session.entryTime)}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                if (session.exceptionNote != null && session.exceptionNote!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.exceptionNote!,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onResolve,
            style: ElevatedButton.styleFrom(
              backgroundColor: _typeColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Xử lý', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
