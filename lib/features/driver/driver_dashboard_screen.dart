import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/models/models.dart';
import '../../shared/utils/responsive.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

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
            // Welcome header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0891B2), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Xin chào, ${svc.currentUser?.fullName ?? 'Bạn'}! 👋',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(svc.buildingName,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Text('Giờ mở cửa: ${svc.openTime} – ${svc.closeTime}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(svc.buildingAddress,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.2),
            const SizedBox(height: 16),

            // Quick Actions — 3 nút
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.home_rounded,
                    label: 'Trang chủ',
                    color: const Color(0xFF7C3AED),
                    onTap: () => context.go('/'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.search_rounded,
                    label: 'Tìm kiếm',
                    color: AppColors.accent,
                    onTap: () => context.go('/driver/map'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickActionButton(
                    icon: Icons.smart_toy_rounded,
                    label: 'Chatbot',
                    color: AppColors.available,
                    onTap: () => context.go('/driver/chat'),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 120.ms).slideY(begin: 0.1),
            const SizedBox(height: 28),

            // Slot availability per floor
            Text('Tình trạng chỗ trống', style: Theme.of(context).textTheme.titleLarge)
                .animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 14),
            ...svc.floors.asMap().entries.map((e) {
              final floor = e.value;
              final total = svc.slotsForFloor(floor.id).length;
              final avail = svc.availableCount(floor.id);
              final pct = total > 0 ? avail / total : 0.0;
              final color = avail == 0
                  ? AppColors.occupied
                  : pct < 0.2
                      ? AppColors.reserved
                      : AppColors.available;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${floor.floorNumber}',
                          style: TextStyle(
                            color: color,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(floor.name,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          avail == 0 ? 'Hết chỗ' : '$avail trống',
                          style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('$total slot', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 200 + e.key * 80));
            }),
            const SizedBox(height: 28),

            // Pricing section — Wrap on mobile
            Text('Bảng giá gửi xe', style: Theme.of(context).textTheme.titleLarge)
                .animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 14),
            isMobile
              ? Column(
                  children: svc.pricingPolicies.asMap().entries.map((e) {
                    final policy = e.value;
                    final colors = {
                      VehicleType.motorbike: AppColors.accent,
                      VehicleType.car: AppColors.primary,
                      VehicleType.truck: AppColors.reserved,
                    };
                    final color = colors[policy.vehicleType]!;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text(policy.vehicleType.icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(policy.vehicleType.label,
                                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                _PriceItem('Theo giờ', '${fmt.format(policy.ratePerHour)}đ'),
                                if (policy.overnightRate != null)
                                  _PriceItem('Qua đêm', '${fmt.format(policy.overnightRate!)}đ'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 450 + e.key * 80));
                  }).toList(),
                )
              : Row(
                  children: svc.pricingPolicies.asMap().entries.map((e) {
                    final policy = e.value;
                    final colors = {
                      VehicleType.motorbike: AppColors.accent,
                      VehicleType.car: AppColors.primary,
                      VehicleType.truck: AppColors.reserved,
                    };
                    final color = colors[policy.vehicleType]!;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: e.key < 2 ? 12.0 : 0),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(policy.vehicleType.icon, style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 8),
                            Text(policy.vehicleType.label,
                                style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            _PriceItem('Theo giờ', '${fmt.format(policy.ratePerHour)}đ'),
                            if (policy.overnightRate != null)
                              _PriceItem('Qua đêm', '${fmt.format(policy.overnightRate!)}đ'),
                            if (policy.monthlyRate != null)
                              _PriceItem('Hàng tháng', '${fmt.format(policy.monthlyRate!)}đ'),
                          ],
                        ),
                      ).animate().fadeIn(delay: Duration(milliseconds: 450 + e.key * 80)),
                    );
                  }).toList(),
                ),
          ],
        ),
      ),
    );
  }
}

class _PriceItem extends StatelessWidget {
  final String label;
  final String value;
  const _PriceItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
