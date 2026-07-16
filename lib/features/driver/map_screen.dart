import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/utils/responsive.dart';

// Ignore web-only imports on non-web targets
// ignore: avoid_web_libraries_in_flutter
import 'map_screen_web.dart' if (dart.library.io) 'map_screen_stub.dart';

// Tọa độ bãi xe: 123 Nguyễn Văn Linh, Q.7, TP.HCM
const _lat = 10.7285;
const _lng = 106.7127;

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = context.watch<MockDataService>();
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 28.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header
            _buildHeader(context),
            const SizedBox(height: 20),

            // ── Distance banner
            _DistanceBanner(address: svc.buildingAddress),
            const SizedBox(height: 16),

            // ── Map widget (iframe on web, styled card on other)
            _MapCard(isMobile: isMobile),
            const SizedBox(height: 24),

            // ── Floor legend
            Text('Chỗ trống theo tầng',
                    style: Theme.of(context).textTheme.titleLarge)
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 12),

            _FloorLegend(svc: svc),
            const SizedBox(height: 24),

            // ── CTA
            _BookingCta(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.map_rounded,
              color: AppColors.accent, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bản đồ bãi xe',
                style: Theme.of(context).textTheme.titleLarge),
            const Text('Vị trí & tình trạng chỗ trống',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.15);
  }
}

// ──────────────────────────────────────────────
// Distance + time banner
// ──────────────────────────────────────────────
class _DistanceBanner extends StatelessWidget {
  final String address;
  const _DistanceBanner({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.accent.withOpacity(0.12),
            AppColors.primary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.near_me_rounded,
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _InfoChip(
                        icon: Icons.directions_car_outlined,
                        label: '~1.8 km',
                        color: AppColors.accent),
                    const SizedBox(width: 12),
                    _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: '~8 phút lái xe',
                        color: AppColors.available),
                    const SizedBox(width: 12),
                    _InfoChip(
                        icon: Icons.directions_walk_rounded,
                        label: '~22 phút đi bộ',
                        color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 80.ms).slideY(begin: -0.1);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 13),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Map card — iframe on web, custom drawn on others
// ──────────────────────────────────────────────
class _MapCard extends StatelessWidget {
  final bool isMobile;
  const _MapCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final mapHeight = isMobile ? 260.0 : 400.0;

    return Container(
      height: mapHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        color: AppColors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map content: iframe on web, fake map on other platforms
          kIsWeb
              ? buildWebMapView(_lat, _lng)
              : _FakeMapCanvas(isMobile: isMobile),

          // Overlay badge – bãi xe pin
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bg.withOpacity(0.90),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_parking_rounded,
                      color: AppColors.primary, size: 15),
                  SizedBox(width: 6),
                  Text('Bãi xe SWP08',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          // Open in Maps button (bottom left)
          Positioned(
            bottom: 12,
            left: 12,
            child: _OpenMapsButton(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 140.ms);
  }
}

// Nút mở Google Maps
class _OpenMapsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Trong prototype chỉ show snackbar, không mở link thật
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mở Google Maps bằng ứng dụng bản đồ của bạn'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.open_in_new_rounded, color: Colors.white, size: 13),
            SizedBox(width: 6),
            Text('Mở Maps',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Fake map canvas cho non-web hoặc khi iframe chưa load
class _FakeMapCanvas extends StatelessWidget {
  final bool isMobile;
  const _FakeMapCanvas({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapGridPainter(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_parking_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bg.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Bãi Xe Thông Minh SWP08',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1;

    // Background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFF0F1A2E));

    // Grid lines (ô vuông giả bản đồ)
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Fake roads
    final roadPaint = Paint()
      ..color = const Color(0xFF1E3A5F)
      ..strokeWidth = 16;

    final mainRoad = size.height * 0.55;
    canvas.drawLine(
        Offset(0, mainRoad), Offset(size.width, mainRoad), roadPaint);

    final sideRoad = size.width * 0.45;
    canvas.drawLine(
        Offset(sideRoad, 0), Offset(sideRoad, size.height), roadPaint);

    // Fake buildings (rectangles)
    final buildingPaint = Paint()..color = const Color(0xFF1E293B);
    final rects = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.08, 80, 50),
      Rect.fromLTWH(size.width * 0.60, size.height * 0.08, 100, 60),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.68, 60, 70),
      Rect.fromLTWH(size.width * 0.60, size.height * 0.68, 90, 55),
    ];
    for (final r in rects) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(4)),
        buildingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ──────────────────────────────────────────────
// Floor availability legend
// ──────────────────────────────────────────────
class _FloorLegend extends StatelessWidget {
  final MockDataService svc;
  const _FloorLegend({required this.svc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: svc.floors.asMap().entries.map((e) {
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
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${floor.floorNumber}',
                    style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(floor.name,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    avail == 0 ? 'Hết chỗ' : '$avail trống',
                    style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('$total slot',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(
            delay: Duration(milliseconds: 240 + e.key * 60));
      }).toList(),
    );
  }
}

// ──────────────────────────────────────────────
// Book now CTA
// ──────────────────────────────────────────────
class _BookingCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.go('/driver/booking'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.bookmark_add_rounded, size: 20),
        label: const Text('Đặt chỗ ngay',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2);
  }
}
