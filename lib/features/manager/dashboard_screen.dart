import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final fmt = NumberFormat('#,###', 'vi_VN');

    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? ScreenUtils.screenPaddingH : 28.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 8,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tổng quan hệ thống',
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy', 'vi').format(DateTime.now()),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.available.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.available.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.available,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${svc.buildingName} – Đang hoạt động',
                        style: const TextStyle(
                            color: AppColors.available,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 28),

            // Stat cards
            _StatCards(svc: svc, fmt: fmt),
            const SizedBox(height: 28),

            // Charts row — Column on mobile, Row on desktop
            if (isMobile) ...
              [
                _HourlyChart(svc: svc),
                const SizedBox(height: 16),
                _FloorOccupancyCard(svc: svc),
                const SizedBox(height: 16),
                _RevenueChart(svc: svc, fmt: fmt),
                const SizedBox(height: 16),
                _ActiveSessionsList(svc: svc),
              ]
            else ...
              [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _HourlyChart(svc: svc)),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _FloorOccupancyCard(svc: svc)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _RevenueChart(svc: svc, fmt: fmt)),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _ActiveSessionsList(svc: svc)),
                  ],
                ),
              ],
          ],
        ),
      ),
    );
  }
}

class _StatCards extends StatelessWidget {
  final MockDataService svc;
  final NumberFormat fmt;
  const _StatCards({required this.svc, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final totalSlots = svc.slots.length;
    final occupied = svc.totalOccupied();
    final available = svc.totalAvailable();
    final rate = (svc.occupancyRate() * 100).toStringAsFixed(1);
    final todayRev = svc.todayRevenue();
    final exceptions = svc.exceptionSessions.length;

    final cards = [
      _StatData(
        label: 'Tổng slot',
        value: totalSlots.toString(),
        sub: 'Toàn bãi',
        icon: Icons.grid_view,
        color: AppColors.primary,
      ),
      _StatData(
        label: 'Đang sử dụng',
        value: occupied.toString(),
        sub: 'slot đang chiếm',
        icon: Icons.directions_car,
        color: AppColors.occupied,
      ),
      _StatData(
        label: 'Slot trống',
        value: available.toString(),
        sub: 'sẵn sàng đón xe',
        icon: Icons.space_bar,
        color: AppColors.available,
      ),
      _StatData(
        label: 'Tỷ lệ lấp đầy',
        value: '$rate%',
        sub: 'hôm nay',
        icon: Icons.donut_large,
        color: AppColors.accent,
      ),
      _StatData(
        label: 'Doanh thu hôm nay',
        value: '${fmt.format(todayRev)}đ',
        sub: 'VND',
        icon: Icons.attach_money,
        color: const Color(0xFF10B981),
      ),
      _StatData(
        label: 'Ngoại lệ',
        value: exceptions.toString(),
        sub: 'cần xử lý',
        icon: Icons.warning_amber,
        color: AppColors.reserved,
      ),
    ];

    final isMobile = Responsive.isMobile(context);
    // On mobile: 2 columns. On desktop: 3 columns with sidebar offset.
    return LayoutBuilder(builder: (ctx, constraints) {
      final cols = isMobile ? 2 : 3;
      final spacing = 16.0;
      final cardWidth = (constraints.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: cards.asMap().entries.map((e) {
          final card = e.value;
          return SizedBox(
            width: cardWidth,
            child: _StatCard(data: card),
          ).animate().fadeIn(delay: Duration(milliseconds: 100 + e.key * 60)).slideY(begin: 0.2);
        }).toList(),
      );
    });
  }
}

class _StatData {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;
  _StatData({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: data.color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.value,
            style: TextStyle(
              color: data.color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(data.sub,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _HourlyChart extends StatelessWidget {
  final MockDataService svc;
  const _HourlyChart({required this.svc});

  @override
  Widget build(BuildContext context) {
    final data = svc.hourlyTrafficToday();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('Lưu lượng xe theo giờ – Hôm nay',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                backgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final h = data[value.toInt()]['hour'] as int;
                        if (h % 3 != 0) return const SizedBox.shrink();
                        return Text('$h:00',
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 10));
                      },
                      reservedSize: 24,
                    ),
                  ),
                ),
                barGroups: data.asMap().entries.map((e) {
                  final count = (e.value['count'] as int).toDouble();
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: count,
                        gradient: const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        width: 12,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _FloorOccupancyCard extends StatelessWidget {
  final MockDataService svc;
  const _FloorOccupancyCard({required this.svc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.layers, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text('Lấp đầy theo tầng', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 20),
          ...svc.floors.map((floor) {
            final total = svc.slotsForFloor(floor.id).length;
            final occ = svc.occupiedCount(floor.id);
            final avail = svc.availableCount(floor.id);
            final pct = total > 0 ? occ / total : 0.0;
            final color = pct > 0.8
                ? AppColors.occupied
                : pct > 0.5
                    ? AppColors.reserved
                    : AppColors.available;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(floor.name,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 13)),
                      Text(
                        '$occ/$total  (trống: $avail)',
                        style: TextStyle(color: color, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms);
  }
}

class _RevenueChart extends StatelessWidget {
  final MockDataService svc;
  final NumberFormat fmt;
  const _RevenueChart({required this.svc, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final data = svc.dailyRevenue7Days();
    final maxRev = data.fold(0.0, (m, d) => d['revenue'] > m ? d['revenue'] as double : m);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Color(0xFF10B981), size: 18),
                  const SizedBox(width: 8),
                  Text('Doanh thu 7 ngày qua', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${fmt.format(svc.weekRevenue())}đ',
                  style: const TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.transparent,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final day = data[value.toInt()]['day'] as DateTime;
                        return Text(
                          DateFormat('dd/MM').format(day),
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                        );
                      },
                      reservedSize: 24,
                    ),
                  ),
                ),
                minY: 0,
                maxY: maxRev * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value['revenue'] as double);
                    }).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), AppColors.accent],
                    ),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF10B981).withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _ActiveSessionsList extends StatelessWidget {
  final MockDataService svc;
  const _ActiveSessionsList({required this.svc});

  @override
  Widget build(BuildContext context) {
    final active = svc.activeSessions.take(5).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_car, color: AppColors.reserved, size: 18),
              const SizedBox(width: 8),
              Text('Xe đang gửi', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.reserved.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${svc.activeSessions.length}',
                  style: const TextStyle(color: AppColors.reserved, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (active.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Không có xe nào đang gửi', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...active.map((s) {
              final dur = DateTime.now().difference(s.entryTime);
              final hrs = dur.inHours;
              final mins = dur.inMinutes % 60;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(s.vehicleType.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.licensePlate,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                          Text('Slot ${s.slotCode}  •  ${hrs}g${mins}m',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    ).animate().fadeIn(delay: 520.ms);
  }
}
