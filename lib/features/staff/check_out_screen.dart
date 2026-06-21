import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/camera_plate_scanner.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _searchCtrl = TextEditingController();
  ParkingSession? _found;
  ParkingSession? _completed;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final fmt = NumberFormat('#,###', 'vi_VN');
    final dtFmt = DateFormat('HH:mm – dd/MM/yyyy');
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          // Search panel
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment:
                        isMobile ? Alignment.center : Alignment.centerLeft,
                    child: Text(
                      'Xe ra (Check-out)',
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: isMobile ? 22 : null),
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 8),
                  const Text('Tìm kiếm lượt gửi theo biển số để xử lý xe ra.',
                          style: TextStyle(color: AppColors.textSecondary))
                      .animate()
                      .fadeIn(delay: 100.ms),
                  const SizedBox(height: 20),

                  CameraPlateScanner(
                    samplePlate: svc.activeSessions.isNotEmpty
                        ? svc.activeSessions.first.licensePlate
                        : '51A-78901',
                    onDetected: (plate) {
                      _searchCtrl.text = plate;
                      _search(svc);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Search box
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Nhập biển số xe (VD: 51A-12345)',
                            prefixIcon: Icon(Icons.search,
                                color: AppColors.textSecondary),
                          ),
                          onSubmitted: (_) => _search(svc),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () => _search(svc),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Tìm kiếm'),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 150.ms),

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                  ],

                  if (isMobile && _completed != null) ...[
                    const SizedBox(height: 20),
                    _CheckOutResult(
                      session: _completed!,
                      fmt: fmt,
                      dtFmt: dtFmt,
                    ),
                  ],

                  if (_found != null && _completed == null) ...[
                    const SizedBox(height: 32),
                    _SessionFoundCard(session: _found!, fmt: fmt, dtFmt: dtFmt),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : () => _doCheckOut(svc),
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.logout),
                        label: const Text('Xác nhận thanh toán & Xe ra',
                            style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.occupied,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],

                  // Active sessions list
                  const SizedBox(height: 32),
                  _ActiveSessionsList(
                      svc: svc,
                      onSelect: (s) {
                        setState(() {
                          _found = s;
                          _completed = null;
                          _error = null;
                          _searchCtrl.text = s.licensePlate;
                        });
                      }),
                ],
              ),
            ),
          ),

          // Result panel
          if (!isMobile)
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: AppColors.border)),
                ),
                child: _completed == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.receipt_long,
                                color: AppColors.textMuted, size: 48),
                            SizedBox(height: 16),
                            Text('Chưa có xe ra',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                            SizedBox(height: 8),
                            Text('Tìm kiếm và xử lý xe ra bên trái.',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      )
                    : _CheckOutResult(
                        session: _completed!, fmt: fmt, dtFmt: dtFmt),
              ),
            ),
        ],
      ),
    );
  }

  void _search(MockDataService svc) {
    final plate = _searchCtrl.text.trim().toUpperCase();
    if (plate.isEmpty) {
      setState(() => _error = 'Vui lòng nhập biển số xe.');
      return;
    }
    final session = svc.findActiveSession(plate);
    setState(() {
      _found = session;
      _completed = null;
      _error = session == null
          ? 'Không tìm thấy xe đang gửi với biển số "$plate".'
          : null;
    });
  }

  void _doCheckOut(MockDataService svc) async {
    if (_found == null) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final session = svc.checkOut(
      sessionId: _found!.id,
      staffId: svc.currentUser?.id ?? 'u002',
    );
    setState(() {
      _loading = false;
      _completed = session;
      _found = null;
    });
  }
}

class _SessionFoundCard extends StatelessWidget {
  final ParkingSession session;
  final NumberFormat fmt;
  final DateFormat dtFmt;
  const _SessionFoundCard(
      {required this.session, required this.fmt, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    final dur = DateTime.now().difference(session.entryTime);
    final rate =
        context.read<MockDataService>().getPriceForType(session.vehicleType);
    final estimatedFee = session.calculateFee(rate);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(session.vehicleType.icon,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.licensePlate,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  Text(session.vehicleType.label,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 24),
          _Row2('Slot', session.slotCode),
          _Row2('Giờ vào', dtFmt.format(session.entryTime)),
          _Row2('Thời gian gửi', '${dur.inHours}g ${dur.inMinutes % 60}m'),
          const Divider(color: AppColors.border, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Phí ước tính:',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              Text(
                '${fmt.format(estimatedFee)}đ',
                style: const TextStyle(
                    color: AppColors.reserved,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}

class _Row2 extends StatelessWidget {
  final String label;
  final String value;
  const _Row2(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _CheckOutResult extends StatelessWidget {
  final ParkingSession session;
  final NumberFormat fmt;
  final DateFormat dtFmt;
  const _CheckOutResult(
      {required this.session, required this.fmt, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: AppColors.available, size: 60),
          const SizedBox(height: 12),
          Text('Xe ra thành công!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: AppColors.available)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _Row2('Biển số', session.licensePlate),
                _Row2('Loại xe',
                    '${session.vehicleType.icon} ${session.vehicleType.label}'),
                _Row2('Slot', session.slotCode),
                _Row2('Giờ vào', dtFmt.format(session.entryTime)),
                _Row2('Giờ ra', dtFmt.format(session.exitTime!)),
                _Row2('Thời gian gửi',
                    '${session.exitTime!.difference(session.entryTime).inHours}g ${session.exitTime!.difference(session.entryTime).inMinutes % 60}m'),
                const Divider(color: AppColors.border, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng phí:',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    Text(
                      '${fmt.format(session.totalFee ?? 0)}đ',
                      style: const TextStyle(
                          color: AppColors.available,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.available.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: AppColors.available, size: 14),
                      SizedBox(width: 6),
                      Text('Đã thanh toán',
                          style: TextStyle(
                              color: AppColors.available, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn().slideX(begin: 0.2),
    );
  }
}

class _ActiveSessionsList extends StatelessWidget {
  final MockDataService svc;
  final ValueChanged<ParkingSession> onSelect;
  const _ActiveSessionsList({required this.svc, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final sessions = svc.activeSessions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Xe đang gửi (${sessions.length})',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...sessions.map((s) {
          final dur = DateTime.now().difference(s.entryTime);
          return ListTile(
            onTap: () => onSelect(s),
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading:
                Text(s.vehicleType.icon, style: const TextStyle(fontSize: 22)),
            title: Text(s.licensePlate,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            subtitle: Text(
                'Slot ${s.slotCode}  •  ${dur.inHours}g${dur.inMinutes % 60}m',
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textMuted),
          );
        }).map((e) =>
            Padding(padding: const EdgeInsets.only(bottom: 8), child: e)),
      ],
    );
  }
}
