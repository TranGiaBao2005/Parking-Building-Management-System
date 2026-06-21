import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class ExceptionManagementScreen extends StatefulWidget {
  const ExceptionManagementScreen({super.key});

  @override
  State<ExceptionManagementScreen> createState() =>
      _ExceptionManagementScreenState();
}

class _ExceptionManagementScreenState extends State<ExceptionManagementScreen> {
  ExceptionType? _filterType; // null = hiển thị tất cả
  String _searchText = '';
  final _searchCtrl = TextEditingController();
  final dtFmt = DateFormat('HH:mm – dd/MM/yyyy');

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final isMobile = Responsive.isMobile(context);

    // Lấy tất cả sessions có exception (bao gồm đã resolved để lịch sử)
    final allExceptions = svc.sessions
        .where((s) => s.exceptionType != ExceptionType.none)
        .toList()
      ..sort((a, b) => b.entryTime.compareTo(a.entryTime));

    final activeExceptions = allExceptions
        .where((s) => s.status == SessionStatus.exception)
        .toList();

    // Lọc theo type + search
    final filtered = allExceptions.where((s) {
      final matchType = _filterType == null || s.exceptionType == _filterType;
      final matchSearch = _searchText.isEmpty ||
          s.licensePlate.toLowerCase().contains(_searchText.toLowerCase()) ||
          s.slotCode.toLowerCase().contains(_searchText.toLowerCase());
      return matchType && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            _buildHeader(context, activeExceptions.length)
                .animate()
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // ── Summary cards ────────────────────────────────────────
            _SummaryCards(allExceptions: allExceptions)
                .animate()
                .fadeIn(delay: 100.ms),
            const SizedBox(height: 24),

            // ── Body: chart (left) + list (right) ───────────────────
            Expanded(
              child: isMobile
                  ? Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _ExceptionList(
                            sessions: filtered,
                            dtFmt: dtFmt,
                            onResolve: (s) =>
                                _showResolveDialog(context, svc, s),
                            onMarkException: (s, type) =>
                                _showMarkExceptionDialog(context, svc, s, type),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 260,
                          child: _LeftPanel(
                            allExceptions: allExceptions,
                            selected: _filterType,
                            onSelect: (t) => setState(() =>
                                _filterType = _filterType == t ? null : t),
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              _buildSearchBar(),
                              const SizedBox(height: 14),
                              Expanded(
                                child: _ExceptionList(
                                  sessions: filtered,
                                  dtFmt: dtFmt,
                                  onResolve: (s) =>
                                      _showResolveDialog(context, svc, s),
                                  onMarkException: (s, type) =>
                                      _showMarkExceptionDialog(
                                          context, svc, s, type),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 250.ms),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, int activeCount) {
    final isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quản lý Ngoại lệ',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            const Text(
              'Theo dõi và xử lý các trường hợp bất thường',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            if (activeCount > 0) ...[
              const SizedBox(height: 12),
              Center(child: _buildActiveBadge(activeCount)),
            ],
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quản lý Ngoại lệ',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 4),
              const Text(
                'Theo dõi & xử lý mất vé, sai biển số, quá giờ, sai khu vực, chưa thanh toán',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (activeCount > 0) _buildActiveBadge(activeCount),
      ],
    );
  }

  Widget _buildActiveBadge(int activeCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFF97316)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 7),
          Text(
            '$activeCount trường hợp cần xử lý',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ──────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Tìm theo biển số hoặc mã slot...',
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.textMuted, size: 18),
              suffixIcon: _searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: AppColors.textMuted, size: 16),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _searchText = '');
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => setState(() => _searchText = v),
          ),
        ),
        const SizedBox(width: 12),
        // Filter active badge
        if (_filterType != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _exTypeColor(_filterType!).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: _exTypeColor(_filterType!).withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Text(
                  _filterType!.label,
                  style: TextStyle(
                      color: _exTypeColor(_filterType!),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => setState(() => _filterType = null),
                  child: Icon(Icons.close,
                      color: _exTypeColor(_filterType!), size: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────
  void _showResolveDialog(
      BuildContext context, MockDataService svc, ParkingSession session) {
    final noteCtrl = TextEditingController(text: session.exceptionNote ?? '');
    String selectedAction = 'resolve';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _exTypeColor(session.exceptionType).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _exTypeIcon(session.exceptionType),
                  color: _exTypeColor(session.exceptionType),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xử lý: ${session.exceptionType.label}',
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 16),
                    ),
                    Text(
                      session.licensePlate,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info row
                _InfoTile(
                    icon: Icons.access_time,
                    label: 'Giờ vào',
                    value: dtFmt.format(session.entryTime)),
                const SizedBox(height: 8),
                _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Vị trí',
                    value: 'Slot ${session.slotCode}'),
                const SizedBox(height: 8),
                _InfoTile(
                    icon: Icons.directions_car_outlined,
                    label: 'Loại xe',
                    value:
                        '${session.vehicleType.icon} ${session.vehicleType.label}'),
                const SizedBox(height: 20),
                const Text('Hành động xử lý',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 10),
                // Action chips
                Wrap(
                  spacing: 8,
                  children: [
                    _ActionChip(
                        label: 'Giải quyết & cho ra',
                        value: 'resolve',
                        selected: selectedAction == 'resolve',
                        color: AppColors.available,
                        onTap: () => setS(() => selectedAction = 'resolve')),
                    _ActionChip(
                        label: 'Đổi loại ngoại lệ',
                        value: 'retype',
                        selected: selectedAction == 'retype',
                        color: AppColors.reserved,
                        onTap: () => setS(() => selectedAction = 'retype')),
                    _ActionChip(
                        label: 'Giữ lại, cập nhật ghi chú',
                        value: 'note',
                        selected: selectedAction == 'note',
                        color: AppColors.primary,
                        onTap: () => setS(() => selectedAction = 'note')),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú xử lý',
                    hintText: 'Mô tả cách giải quyết vấn đề...',
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
            ElevatedButton.icon(
              onPressed: () {
                if (selectedAction == 'resolve') {
                  svc.resolveException(session.id, noteCtrl.text);
                  // Also do a checkout so session becomes completed
                  svc.checkOutException(
                      sessionId: session.id,
                      staffId: svc.currentUser?.id ?? 'u002',
                      note: noteCtrl.text);
                } else {
                  svc.resolveException(session.id, noteCtrl.text);
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Đã xử lý ngoại lệ cho xe ${session.licensePlate}'),
                    backgroundColor: AppColors.available,
                  ),
                );
              },
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Xác nhận xử lý'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.available),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkExceptionDialog(BuildContext context, MockDataService svc,
      ParkingSession session, ExceptionType type) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Đánh dấu: ${type.label}',
            style: const TextStyle(color: AppColors.textPrimary)),
        content: SizedBox(
          width: 380,
          child: TextField(
            controller: noteCtrl,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Ghi chú',
              hintText: 'Thêm thông tin về trường hợp này...',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              svc.markAsException(
                  sessionId: session.id,
                  exceptionType: type,
                  note: noteCtrl.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Đã đánh dấu xe ${session.licensePlate} là ${type.label}'),
                  backgroundColor: _exTypeColor(type),
                ),
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: _exTypeColor(type)),
            child: const Text('Đánh dấu'),
          ),
        ],
      ),
    );
  }
}

// ── Left panel: donut + type filter ──────────────────────────────────────────
class _LeftPanel extends StatelessWidget {
  final List<ParkingSession> allExceptions;
  final ExceptionType? selected;
  final ValueChanged<ExceptionType> onSelect;

  const _LeftPanel({
    required this.allExceptions,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final types =
        ExceptionType.values.where((t) => t != ExceptionType.none).toList();

    return Column(
      children: [
        // Donut chart
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Text('Phân loại ngoại lệ',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: allExceptions.isEmpty
                    ? const Center(
                        child: Text('Không có dữ liệu',
                            style: TextStyle(color: AppColors.textMuted)))
                    : PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 36,
                          sections: types
                              .map((t) {
                                final count = allExceptions
                                    .where((s) => s.exceptionType == t)
                                    .length;
                                if (count == 0) return null;
                                return PieChartSectionData(
                                  value: count.toDouble(),
                                  color: _exTypeColor(t),
                                  radius: selected == t ? 50 : 40,
                                  title: '$count',
                                  titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              })
                              .whereType<PieChartSectionData>()
                              .toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Type filter list
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Text('Lọc theo loại',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 12),
                ...types.map((t) {
                  final count =
                      allExceptions.where((s) => s.exceptionType == t).length;
                  final activeCount = allExceptions
                      .where((s) =>
                          s.exceptionType == t &&
                          s.status == SessionStatus.exception)
                      .length;
                  final isSelected = selected == t;
                  return GestureDetector(
                    onTap: () => onSelect(t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _exTypeColor(t).withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(
                                color: _exTypeColor(t).withOpacity(0.5))
                            : Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(_exTypeIcon(t),
                              color: _exTypeColor(t), size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.label,
                                    style: TextStyle(
                                        color: isSelected
                                            ? _exTypeColor(t)
                                            : AppColors.textPrimary,
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal)),
                                if (activeCount > 0)
                                  Text('$activeCount đang chờ',
                                      style: TextStyle(
                                          color: _exTypeColor(t),
                                          fontSize: 10)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _exTypeColor(t).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$count',
                                style: TextStyle(
                                    color: _exTypeColor(t),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Summary stat cards ────────────────────────────────────────────────────────
class _SummaryCards extends StatelessWidget {
  final List<ParkingSession> allExceptions;
  const _SummaryCards({required this.allExceptions});

  @override
  Widget build(BuildContext context) {
    final active =
        allExceptions.where((s) => s.status == SessionStatus.exception).length;
    final resolved =
        allExceptions.where((s) => s.status != SessionStatus.exception).length;
    final overtime = allExceptions
        .where((s) => s.exceptionType == ExceptionType.overtime)
        .length;
    final lostTicket = allExceptions
        .where((s) => s.exceptionType == ExceptionType.lostTicket)
        .length;
    final wrongPlate = allExceptions
        .where((s) => s.exceptionType == ExceptionType.wrongPlate)
        .length;
    final unpaid = allExceptions
        .where((s) => s.exceptionType == ExceptionType.unpaid)
        .length;

    final stats = [
      _Stat('Đang chờ xử lý', '$active', AppColors.occupied,
          Icons.pending_actions),
      _Stat('Đã giải quyết', '$resolved', AppColors.available,
          Icons.check_circle_outline),
      _Stat('Quá giờ', '$overtime', const Color(0xFFEF4444),
          Icons.timer_off_outlined),
      _Stat('Mất vé', '$lostTicket', AppColors.reserved,
          Icons.confirmation_number_outlined),
      _Stat('Sai biển số', '$wrongPlate', AppColors.locked,
          Icons.no_crash_outlined),
      _Stat('Chưa thanh toán', '$unpaid', const Color(0xFFF97316),
          Icons.money_off_outlined),
    ];

    final isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.asMap().entries.map((e) {
            return SizedBox(
              width: 145,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _StatCard(stat: e.value),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Row(
      children: stats.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: e.key < stats.length - 1 ? 12 : 0),
            child: _StatCard(stat: e.value),
          ),
        );
      }).toList(),
    );
  }
}

class _Stat {
  final String label, value;
  final Color color;
  final IconData icon;
  const _Stat(this.label, this.value, this.color, this.icon);
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: stat.color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ),
              const SizedBox(width: 6),
              Icon(stat.icon, color: stat.color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(stat.value,
              style: TextStyle(
                  color: stat.color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── Exception list ────────────────────────────────────────────────────────────
class _ExceptionList extends StatelessWidget {
  final List<ParkingSession> sessions;
  final DateFormat dtFmt;
  final ValueChanged<ParkingSession> onResolve;
  final void Function(ParkingSession, ExceptionType) onMarkException;

  const _ExceptionList({
    required this.sessions,
    required this.dtFmt,
    required this.onResolve,
    required this.onMarkException,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                    color: AppColors.available, size: 64)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2.seconds, color: AppColors.available),
            const SizedBox(height: 16),
            const Text('Không tìm thấy ngoại lệ nào phù hợp',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        return _ExceptionCard(
          session: sessions[i],
          dtFmt: dtFmt,
          onResolve: () => onResolve(sessions[i]),
          onMarkException: (type) => onMarkException(sessions[i], type),
        ).animate().fadeIn(delay: Duration(milliseconds: 50 * i));
      },
    );
  }
}

class _ExceptionCard extends StatefulWidget {
  final ParkingSession session;
  final DateFormat dtFmt;
  final VoidCallback onResolve;
  final ValueChanged<ExceptionType> onMarkException;

  const _ExceptionCard({
    required this.session,
    required this.dtFmt,
    required this.onResolve,
    required this.onMarkException,
  });

  @override
  State<_ExceptionCard> createState() => _ExceptionCardState();
}

class _ExceptionCardState extends State<_ExceptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final color = _exTypeColor(s.exceptionType);
    final dur = DateTime.now().difference(s.entryTime);
    final isActive = s.status == SessionStatus.exception;
    final isResolved = !isActive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isResolved ? AppColors.border : color.withOpacity(0.45),
          width: isResolved ? 1 : 1.5,
        ),
      ),
      child: Column(
        children: [
          // Main row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Type icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(isResolved ? 0.08 : 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_exTypeIcon(s.exceptionType),
                      color: isResolved ? color.withOpacity(0.5) : color,
                      size: 20),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              s.exceptionType.label,
                              style: TextStyle(
                                  color: isResolved
                                      ? color.withOpacity(0.6)
                                      : color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status badge
                          if (Responsive.isMobile(context))
                            Icon(
                              isResolved
                                  ? Icons.check_circle
                                  : Icons.warning_rounded,
                              color: isResolved
                                  ? AppColors.available
                                  : AppColors.occupied,
                              size: 15,
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isResolved
                                    ? AppColors.available.withOpacity(0.1)
                                    : AppColors.occupied.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isResolved ? '✓ Đã xử lý' : '⚠ Chờ xử lý',
                                style: TextStyle(
                                    color: isResolved
                                        ? AppColors.available
                                        : AppColors.occupied,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (!Responsive.isMobile(context)) ...[
                            const Spacer(),
                            Text(
                              '${dur.inHours}g ${dur.inMinutes % 60}m',
                              style: TextStyle(
                                  color: dur.inHours > 24
                                      ? AppColors.occupied
                                      : AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: dur.inHours > 24
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            s.licensePlate,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${s.vehicleType.icon} ${s.vehicleType.label}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Slot ${s.slotCode}  •  Vào: ${widget.dtFmt.format(s.entryTime)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 11),
                      ),
                      if (s.exceptionNote != null &&
                          s.exceptionNote!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.notes,
                                size: 12, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                s.exceptionNote!,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Actions
                Column(
                  children: [
                    if (isActive)
                      Responsive.isMobile(context)
                          ? IconButton.filled(
                              onPressed: widget.onResolve,
                              style:
                                  IconButton.styleFrom(backgroundColor: color),
                              icon: const Icon(Icons.check,
                                  color: Colors.white, size: 18),
                            )
                          : ElevatedButton.icon(
                              onPressed: widget.onResolve,
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text('Xử lý',
                                  style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                    const SizedBox(height: 6),
                    // Expand toggle
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Responsive.isMobile(context)
                            ? Icon(
                                _expanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: AppColors.textMuted,
                                size: 18,
                              )
                            : Row(
                                children: [
                                  Text(
                                    _expanded ? 'Thu gọn' : 'Chi tiết',
                                    style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 11),
                                  ),
                                  Icon(
                                    _expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: AppColors.textMuted,
                                    size: 14,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expanded: quick action bar
          if (_expanded)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: color.withOpacity(0.2))),
                color: AppColors.bg.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(14)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Đánh dấu lại loại ngoại lệ:',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: ExceptionType.values
                        .where((t) =>
                            t != ExceptionType.none && t != s.exceptionType)
                        .map((t) => GestureDetector(
                              onTap: () => widget.onMarkException(t),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _exTypeColor(t).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: _exTypeColor(t).withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_exTypeIcon(t),
                                        color: _exTypeColor(t), size: 12),
                                    const SizedBox(width: 5),
                                    Text(t.label,
                                        style: TextStyle(
                                            color: _exTypeColor(t),
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
Color _exTypeColor(ExceptionType t) {
  switch (t) {
    case ExceptionType.lostTicket:
      return AppColors.reserved;
    case ExceptionType.wrongPlate:
      return AppColors.locked;
    case ExceptionType.overtime:
      return const Color(0xFFEF4444);
    case ExceptionType.unpaid:
      return const Color(0xFFF97316);
    case ExceptionType.wrongZone:
      return AppColors.maintenance;
    default:
      return AppColors.textMuted;
  }
}

IconData _exTypeIcon(ExceptionType t) {
  switch (t) {
    case ExceptionType.lostTicket:
      return Icons.confirmation_number_outlined;
    case ExceptionType.wrongPlate:
      return Icons.no_crash_outlined;
    case ExceptionType.overtime:
      return Icons.timer_off_outlined;
    case ExceptionType.unpaid:
      return Icons.money_off_outlined;
    case ExceptionType.wrongZone:
      return Icons.wrong_location_outlined;
    default:
      return Icons.warning_amber_outlined;
  }
}

// ── Small helper widgets ───────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text('$label: ',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label, value;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selected ? color : AppColors.border, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: selected ? color : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal),
        ),
      ),
    );
  }
}
