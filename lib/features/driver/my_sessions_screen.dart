import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every minute to refresh real-time fee
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final user = svc.currentUser;
    final fmt = NumberFormat('#,###', 'vi_VN');
    final dtFmt = DateFormat('HH:mm – dd/MM/yyyy');

    final activeSessions = user != null ? svc.activeSessionsForUser(user.id) : [];
    final allCompleted = svc.completedSessions.take(10).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lượt gửi xe của tôi', style: Theme.of(context).textTheme.displayMedium)
                .animate().fadeIn(),
            const SizedBox(height: 8),
            const Text('Xem giờ vào và phí tạm tính theo thời gian thực.',
                style: TextStyle(color: AppColors.textSecondary))
                .animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 28),

            // Active sessions
            if (activeSessions.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.available,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Đang gửi xe', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  const Text('(phí cập nhật mỗi phút)',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 14),
              ...activeSessions.map((s) => _ActiveSessionCard(
                session: s,
                fmt: fmt,
                dtFmt: dtFmt,
                svc: svc,
              ).animate().fadeIn()),
              const SizedBox(height: 28),
            ],

            // History
            Text('Lịch sử gửi xe', style: Theme.of(context).textTheme.titleLarge)
                .animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 14),
            if (allCompleted.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Chưa có lịch sử gửi xe.',
                      style: TextStyle(color: AppColors.textMuted)),
                ),
              )
            else
              ...allCompleted.asMap().entries.map((e) => _HistorySessionCard(
                session: e.value,
                fmt: fmt,
                dtFmt: dtFmt,
              ).animate().fadeIn(delay: Duration(milliseconds: 200 + e.key * 50))),
          ],
        ),
      ),
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final ParkingSession session;
  final NumberFormat fmt;
  final DateFormat dtFmt;
  final MockDataService svc;
  const _ActiveSessionCard({
    required this.session,
    required this.fmt,
    required this.dtFmt,
    required this.svc,
  });

  @override
  Widget build(BuildContext context) {
    final dur = DateTime.now().difference(session.entryTime);
    final rate = svc.getPriceForType(session.vehicleType);
    final fee = session.calculateFee(rate);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.available.withOpacity(0.1),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.available.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(session.vehicleType.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.licensePlate,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    Text('${session.vehicleType.label}  •  Slot ${session.slotCode}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.available.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Đang gửi',
                    style: TextStyle(color: AppColors.available, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimeMetric(
                icon: Icons.login,
                label: 'Giờ vào',
                value: DateFormat('HH:mm').format(session.entryTime),
                color: AppColors.primary,
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              _TimeMetric(
                icon: Icons.timer,
                label: 'Thời gian',
                value: '${dur.inHours}g ${dur.inMinutes % 60}m',
                color: AppColors.accent,
              ),
              Container(width: 1, height: 40, color: AppColors.border),
              _TimeMetric(
                icon: Icons.attach_money,
                label: 'Phí tạm tính',
                value: '${fmt.format(fee)}đ',
                color: AppColors.reserved,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _TimeMetric({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}

class _HistorySessionCard extends StatelessWidget {
  final ParkingSession session;
  final NumberFormat fmt;
  final DateFormat dtFmt;
  const _HistorySessionCard({required this.session, required this.fmt, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    final dur = session.exitTime != null
        ? session.exitTime!.difference(session.entryTime)
        : Duration.zero;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(session.vehicleType.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.licensePlate,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '${dtFmt.format(session.entryTime)}  →  ${session.exitTime != null ? DateFormat("HH:mm").format(session.exitTime!) : "?"}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
                Text('${dur.inHours}g${dur.inMinutes % 60}m  •  Slot ${session.slotCode}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          if (session.totalFee != null)
            Text(
              '${fmt.format(session.totalFee!)}đ',
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
