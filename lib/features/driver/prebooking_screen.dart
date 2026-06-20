import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';

class PrebookingScreen extends StatefulWidget {
  const PrebookingScreen({super.key});

  @override
  State<PrebookingScreen> createState() => _PrebookingScreenState();
}

class _PrebookingScreenState extends State<PrebookingScreen> {
  final _plateCtrl = TextEditingController();
  VehicleType _vehicleType = VehicleType.car;
  String _floorId = 'f3';
  DateTime _entryTime = DateTime.now().add(const Duration(hours: 2));
  DateTime _exitTime = DateTime.now().add(const Duration(hours: 6));
  Prebooking? _result;
  bool _loading = false;

  final _floorsByType = {
    VehicleType.motorbike: ['f1', 'f2'],
    VehicleType.car: ['f3', 'f4'],
    VehicleType.truck: ['f4'],
  };

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final dtFmt = DateFormat('HH:mm – dd/MM');
    final fmt = NumberFormat('#,###', 'vi_VN');

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          // Form
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đặt chỗ trước', style: Theme.of(context).textTheme.displayMedium)
                      .animate().fadeIn(),
                  const SizedBox(height: 8),
                  const Text('Đặt slot theo loại xe, thời gian và khu vực.',
                      style: TextStyle(color: AppColors.textSecondary))
                      .animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 32),

                  // License plate
                  TextField(
                    controller: _plateCtrl,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Biển số xe',
                      hintText: 'VD: 51A-12345',
                      prefixIcon: Icon(Icons.directions_car_outlined, color: AppColors.textSecondary),
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 20),

                  // Vehicle type
                  const Text('Loại phương tiện', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(t.icon, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(height: 4),
                                  Text(t.label,
                                      style: TextStyle(
                                          color: isSelected ? AppColors.accent : AppColors.textSecondary,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 20),

                  // Floor
                  const Text('Khu vực / Tầng', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                            onTap: avail > 0 ? () => setState(() => _floorId = fid) : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.accent : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(floor.name,
                                      style: TextStyle(
                                          color: isSelected ? AppColors.accent : AppColors.textPrimary,
                                          fontSize: 12, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center),
                                  Text('Trống: $avail',
                                      style: TextStyle(
                                          color: avail > 0 ? AppColors.available : AppColors.occupied,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 250.ms),
                  const SizedBox(height: 20),

                  // Time selection
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'Giờ vào dự kiến',
                          value: _entryTime,
                          onPick: (dt) => setState(() => _entryTime = dt),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _TimePickerField(
                          label: 'Giờ ra dự kiến',
                          value: _exitTime,
                          onPick: (dt) => setState(() => _exitTime = dt),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 28),

                  // Fee estimate
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phí ước tính:', style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          () {
                            final hours = _exitTime.difference(_entryTime).inMinutes / 60.0;
                            final rate = svc.getPriceForType(_vehicleType);
                            final fee = (hours * rate).ceil().toDouble();
                            return '${fmt.format(fee)}đ';
                          }(),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : () => _doBook(svc),
                      icon: _loading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.bookmark_add),
                      label: const Text('Xác nhận đặt chỗ', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // My bookings panel
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.border)),
              ),
              child: _result != null
                  ? _BookingSuccess(booking: _result!, dtFmt: dtFmt)
                  : _MyBookings(svc: svc, dtFmt: dtFmt),
            ),
          ),
        ],
      ),
    );
  }

  void _doBook(MockDataService svc) async {
    if (_plateCtrl.text.trim().isEmpty) return;
    if (_exitTime.isBefore(_entryTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giờ ra phải sau giờ vào!')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final booking = svc.createPrebooking(
      userId: svc.currentUser?.id ?? 'u004',
      userFullName: svc.currentUser?.fullName ?? 'Khách',
      vehicleType: _vehicleType,
      licensePlate: _plateCtrl.text.trim().toUpperCase(),
      floorId: _floorId,
      expectedEntry: _entryTime,
      expectedExit: _exitTime,
    );
    setState(() {
      _loading = false;
      _result = booking;
    });
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onPick;
  const _TimePickerField({required this.label, required this.value, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(value));
        if (time == null) return;
        onPick(DateTime(date.year, date.month, date.day, time.hour, time.minute));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: AppColors.accent, size: 14),
                const SizedBox(width: 6),
                Text(
                  DateFormat('HH:mm – dd/MM/yyyy').format(value),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingSuccess extends StatelessWidget {
  final Prebooking booking;
  final DateFormat dtFmt;
  const _BookingSuccess({required this.booking, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.bookmark_added, color: AppColors.accent, size: 60),
          const SizedBox(height: 12),
          Text('Đặt chỗ thành công!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.accent)),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
            ),
            child: Column(
              children: [
                Text(
                  booking.confirmationCode ?? 'N/A',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Mã xác nhận', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const Divider(color: AppColors.border, height: 24),
                _BookRow('Biển số', booking.licensePlate),
                _BookRow('Loại xe', '${booking.vehicleType.icon} ${booking.vehicleType.label}'),
                if (booking.assignedSlotCode != null)
                  _BookRow('Slot', booking.assignedSlotCode!),
                _BookRow('Vào', dtFmt.format(booking.expectedEntry)),
                _BookRow('Ra', dtFmt.format(booking.expectedExit)),
              ],
            ),
          ),
        ],
      ).animate().fadeIn().slideX(begin: 0.2),
    );
  }
}

class _BookRow extends StatelessWidget {
  final String label;
  final String value;
  const _BookRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _MyBookings extends StatelessWidget {
  final MockDataService svc;
  final DateFormat dtFmt;
  const _MyBookings({required this.svc, required this.dtFmt});

  @override
  Widget build(BuildContext context) {
    final userId = svc.currentUser?.id ?? '';
    final bookings = svc.prebookingsForUser(userId);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Đặt chỗ của tôi', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          if (bookings.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Chưa có đặt chỗ nào.', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...bookings.map((b) {
              final statusColor = b.status == PrebookingStatus.confirmed
                  ? AppColors.available
                  : b.status == PrebookingStatus.pending
                      ? AppColors.reserved
                      : AppColors.textMuted;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(b.licensePlate,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            b.status.name,
                            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(b.confirmationCode ?? '',
                        style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text('${dtFmt.format(b.expectedEntry)} → ${DateFormat("HH:mm").format(b.expectedExit)}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    if (b.assignedSlotCode != null)
                      Text('Slot: ${b.assignedSlotCode}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
