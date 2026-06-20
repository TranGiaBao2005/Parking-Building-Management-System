import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final fmt = NumberFormat('#,###', 'vi_VN');
    final dtFmt = DateFormat('dd/MM/yyyy HH:mm');
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Báo cáo & Thống kê',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: isMobile ? 22 : null,
                    ),
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 20),
            TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Lượt xe vào/ra'),
                Tab(text: 'Doanh thu'),
                Tab(text: 'Ngoại lệ & Sự cố'),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _VehicleLogTab(svc: svc, dtFmt: dtFmt, fmt: fmt),
                  _RevenueTab(svc: svc, fmt: fmt, dtFmt: dtFmt),
                  _ExceptionTab(svc: svc, dtFmt: dtFmt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleLogTab extends StatelessWidget {
  final MockDataService svc;
  final DateFormat dtFmt;
  final NumberFormat fmt;
  const _VehicleLogTab(
      {required this.svc, required this.dtFmt, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final all = [...svc.activeSessions, ...svc.completedSessions]
      ..sort((a, b) => b.entryTime.compareTo(a.entryTime));

    final todayIn = svc.sessions
        .where((s) =>
            s.entryTime.day == DateTime.now().day &&
            s.entryTime.month == DateTime.now().month)
        .length;
    final todayOut = svc.completedSessions
        .where((s) =>
            s.exitTime?.day == DateTime.now().day &&
            s.exitTime?.month == DateTime.now().month)
        .length;

    return Column(
      children: [
        // Summary row
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniStat('Xe vào hôm nay', '$todayIn lượt', AppColors.primary),
            _MiniStat('Xe ra hôm nay', '$todayOut lượt', AppColors.available),
            _MiniStat('Đang gửi', '${svc.activeSessions.length} xe',
                AppColors.reserved),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 20),
        Expanded(
          child: _DataTable(
            headers: const [
              'Biển số',
              'Loại xe',
              'Slot',
              'Giờ vào',
              'Giờ ra',
              'Phí',
              'Trạng thái'
            ],
            rows: all
                .take(50)
                .map((s) => [
                      s.licensePlate,
                      '${s.vehicleType.icon} ${s.vehicleType.label}',
                      s.slotCode,
                      dtFmt.format(s.entryTime),
                      s.exitTime != null ? dtFmt.format(s.exitTime!) : '—',
                      s.totalFee != null ? '${fmt.format(s.totalFee!)}đ' : '—',
                      s.status == SessionStatus.active
                          ? 'Đang gửi'
                          : s.status == SessionStatus.completed
                              ? 'Hoàn thành'
                              : 'Ngoại lệ',
                    ])
                .toList(),
            statusColors: all
                .take(50)
                .map((s) => s.status == SessionStatus.active
                    ? AppColors.available
                    : s.status == SessionStatus.completed
                        ? AppColors.textSecondary
                        : AppColors.occupied)
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _RevenueTab extends StatelessWidget {
  final MockDataService svc;
  final NumberFormat fmt;
  final DateFormat dtFmt;
  const _RevenueTab(
      {required this.svc, required this.dtFmt, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final data = svc.dailyRevenue7Days();
    final weekTotal = svc.weekRevenue();
    final todayTotal = svc.todayRevenue();

    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniStat('Doanh thu hôm nay', '${fmt.format(todayTotal)}đ',
                AppColors.available),
            _MiniStat('Doanh thu 7 ngày', '${fmt.format(weekTotal)}đ',
                AppColors.primary),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 20),
        Expanded(
          child: _DataTable(
            headers: const ['Ngày', 'Số lượt', 'Tổng thu', 'TB/lượt'],
            rows: data.map((d) {
              final day = d['day'] as DateTime;
              final rev = d['revenue'] as double;
              final count = svc.sessions
                  .where((s) =>
                      s.exitTime?.day == day.day &&
                      s.exitTime?.month == day.month &&
                      s.exitTime?.year == day.year &&
                      s.status == SessionStatus.completed)
                  .length;
              final avg = count > 0 ? rev / count : 0;
              return [
                DateFormat('EEEE, dd/MM/yyyy', 'vi').format(day),
                '$count lượt',
                '${fmt.format(rev)}đ',
                '${fmt.format(avg)}đ',
              ];
            }).toList(),
            statusColors: null,
          ),
        ),
      ],
    );
  }
}

class _ExceptionTab extends StatelessWidget {
  final MockDataService svc;
  final DateFormat dtFmt;
  const _ExceptionTab({required this.svc, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    final exceptions = svc.exceptionSessions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _MiniStat('Tổng ngoại lệ', '${exceptions.length} trường hợp',
                AppColors.occupied),
          ],
        ).animate().fadeIn(),
        const SizedBox(height: 20),
        Expanded(
          child: _DataTable(
            headers: const [
              'Biển số',
              'Loại xe',
              'Slot',
              'Giờ vào',
              'Loại ngoại lệ',
              'Ghi chú'
            ],
            rows: exceptions
                .map((s) => [
                      s.licensePlate,
                      '${s.vehicleType.icon} ${s.vehicleType.label}',
                      s.slotCode,
                      dtFmt.format(s.entryTime),
                      s.exceptionType.label,
                      s.exceptionNote ?? '—',
                    ])
                .toList(),
            statusColors: exceptions.map((_) => AppColors.occupied).toList(),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              Text(value,
                  style: TextStyle(
                      color: color, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DataTable extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> rows;
  final List<Color>? statusColors;
  const _DataTable(
      {required this.headers, required this.rows, required this.statusColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: (headers.length * 130).toDouble(),
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder(
                  horizontalInside:
                      const BorderSide(color: AppColors.border, width: 1),
                  bottom: const BorderSide(color: AppColors.border),
                ),
                columnWidths: const {0: FixedColumnWidth(130)},
                children: [
                  // Header
                  TableRow(
                    decoration:
                        const BoxDecoration(color: AppColors.surfaceLight),
                    children: headers
                        .map((h) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Text(h,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ))
                        .toList(),
                  ),
                  // Data rows
                  ...rows.asMap().entries.map((entry) {
                    final i = entry.key;
                    final row = entry.value;
                    return TableRow(
                      children: row.asMap().entries.map((cell) {
                        final isLast = cell.key == row.length - 1;
                        final color = isLast &&
                                statusColors != null &&
                                i < statusColors!.length
                            ? statusColors![i]
                            : AppColors.textPrimary;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          child: Text(
                            cell.value,
                            style: TextStyle(color: color, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
