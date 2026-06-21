import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/camera_plate_scanner.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _plateCtrl = TextEditingController();
  VehicleType _vehicleType = VehicleType.motorbike;
  String _floorId = 'f1';
  ParkingSession? _result;
  bool _loading = false;
  String? _error;

  final _floorsByType = {
    VehicleType.motorbike: ['f1', 'f2'],
    VehicleType.car: ['f3', 'f4'],
    VehicleType.truck: ['f4'],
  };

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final available = svc.availableCount(_floorId);
    final total = svc.slotsForFloor(_floorId).length;

    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: isMobile
          ? SingleChildScrollView(
              child: Column(
                children: [
                  _buildForm(context, svc, available, total),
                  if (_result != null) ...[
                    const Divider(color: AppColors.border, height: 1),
                    _CheckInResultPanel(session: _result!),
                  ],
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: _buildFormContent(context, svc, available, total),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.border)),
                    ),
                    child: _result == null
                        ? _PlaceholderPanel()
                        : _CheckInResultPanel(session: _result!),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildForm(
      BuildContext context, MockDataService svc, int available, int total) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: _buildFormContent(context, svc, available, total),
    );
  }

  Widget _buildFormContent(
      BuildContext context, MockDataService svc, int available, int total) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isMobile ? Alignment.center : Alignment.centerLeft,
          child: Text(
            'Xe vào (Check-in)',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: isMobile ? 22 : null,
                ),
          ),
        ).animate().fadeIn(),
        const SizedBox(height: 8),
        const Text('Nhập thông tin xe và tạo lượt gửi.',
                style: TextStyle(color: AppColors.textSecondary))
            .animate()
            .fadeIn(delay: 100.ms),
        const SizedBox(height: 20),

        CameraPlateScanner(
          samplePlate: '51A-12345',
          onDetected: (plate) => setState(() {
            _plateCtrl.text = plate;
            _error = null;
          }),
        ),
        const SizedBox(height: 24),

        // Plate input
        _SectionLabel('Biển số xe'),
        const SizedBox(height: 8),
        TextField(
          controller: _plateCtrl,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'VD: 51A-12345',
            prefixIcon: const Icon(Icons.confirmation_number_outlined,
                color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) => setState(() => _error = null),
        ).animate().fadeIn(delay: 150.ms),
        const SizedBox(height: 24),

        // Vehicle type
        _SectionLabel('Loại phương tiện'),
        const SizedBox(height: 10),
        Row(
          children: VehicleType.values.map((t) {
            final isSelected = _vehicleType == t;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _vehicleType = t;
                    _floorId = _floorsByType[t]!.first;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(t.icon, style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(t.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 24),

        // Floor selection
        _SectionLabel('Chọn tầng'),
        const SizedBox(height: 10),
        Row(
          children: (_floorsByType[_vehicleType] ?? []).map((fid) {
            final floor = svc.floors.firstWhere((f) => f.id == fid);
            final avail = svc.availableCount(fid);
            final isSelected = _floorId == fid;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _floorId = fid),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF10B981).withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(floor.name,
                            style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF10B981)
                                    : AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        Text('Trống: $avail',
                            style: TextStyle(
                                color: avail > 0
                                    ? AppColors.available
                                    : AppColors.occupied,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 12),

        // Availability indicator
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: available > 0
                ? AppColors.available.withOpacity(0.1)
                : AppColors.occupied.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: available > 0
                  ? AppColors.available.withOpacity(0.3)
                  : AppColors.occupied.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                available > 0 ? Icons.check_circle : Icons.cancel,
                color: available > 0 ? AppColors.available : AppColors.occupied,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  available > 0
                      ? 'Còn $available/$total slot trống tại tầng này'
                      : 'Tầng này đã đầy! Vui lòng chọn tầng khác.',
                  style: TextStyle(
                    color: available > 0
                        ? AppColors.available
                        : AppColors.occupied,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_error!,
                style: const TextStyle(color: Colors.red, fontSize: 13)),
          ),
        ],
        const SizedBox(height: 24),

        // Check-in button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: (_loading || available == 0) ? null : _doCheckIn,
            icon: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.login),
            label:
                const Text('Tạo lượt gửi xe', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  void _doCheckIn() async {
    if (_plateCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Vui lòng nhập biển số xe.');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final svc = context.read<MockDataService>();
    final session = svc.checkIn(
      licensePlate: _plateCtrl.text.trim().toUpperCase(),
      vehicleType: _vehicleType,
      floorId: _floorId,
      staffId: svc.currentUser?.id ?? 'u002',
    );

    setState(() {
      _loading = false;
      if (session == null) {
        _error = 'Không tìm thấy slot trống. Vui lòng thử tầng khác.';
      } else {
        _result = session;
        _plateCtrl.clear();
      }
    });
  }
}

Widget _SectionLabel(String text) => Text(
      text,
      style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500),
    );

class _PlaceholderPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.login, color: AppColors.textMuted, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('Chưa có lượt gửi xe',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          const SizedBox(height: 8),
          const Text('Điền thông tin xe và nhấn tạo lượt gửi.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CheckInResultPanel extends StatelessWidget {
  final ParkingSession session;
  const _CheckInResultPanel({required this.session});

  @override
  Widget build(BuildContext context) {
    final dtFmt = DateFormat('HH:mm – dd/MM/yyyy');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 56),
          const SizedBox(height: 12),
          Text('Check-in thành công!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Color(0xFF10B981))),
          const SizedBox(height: 24),
          // QR code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data:
                  'SESSION:${session.id}|${session.licensePlate}|${session.slotCode}',
              version: QrVersions.auto,
              size: 160,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Session info
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
                _InfoRow2('Biển số', session.licensePlate),
                _InfoRow2('Loại xe',
                    '${session.vehicleType.icon} ${session.vehicleType.label}'),
                _InfoRow2('Slot được cấp', session.slotCode),
                _InfoRow2('Giờ vào', dtFmt.format(session.entryTime)),
                _InfoRow2(
                    'Mã session', session.id.substring(0, 8).toUpperCase()),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.primaryLight, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Hướng dẫn đến slot ${session.slotCode}',
                    style: const TextStyle(
                        color: AppColors.primaryLight, fontSize: 13),
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

class _InfoRow2 extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow2(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
