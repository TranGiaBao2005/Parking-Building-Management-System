import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

// ============================================================
//  Data
// ============================================================
class _Cell {
  final IconData icon;
  final Color color;
  final String label;
  const _Cell(this.icon, this.color, this.label);
}

const _kTraffic = [
  _Cell(Icons.traffic,           Color(0xFFEF4444), 'đèn đỏ'),
  _Cell(Icons.traffic,           Color(0xFFF59E0B), 'đèn vàng'),
  _Cell(Icons.traffic,           Color(0xFF10B981), 'đèn xanh'),
];
const _kCars = [
  _Cell(Icons.directions_car,    Color(0xFF6366F1), 'xe sedan'),
  _Cell(Icons.airport_shuttle,   Color(0xFF06B6D4), 'xe van'),
  _Cell(Icons.local_taxi,        Color(0xFFF59E0B), 'taxi'),
];
const _kMotos = [
  _Cell(Icons.two_wheeler,       Color(0xFFEC4899), 'xe máy'),
  _Cell(Icons.pedal_bike,        Color(0xFF10B981), 'xe đạp'),
  _Cell(Icons.electric_moped,    Color(0xFF8B5CF6), 'xe điện'),
];
const _kSigns = [
  _Cell(Icons.do_not_disturb_on, Color(0xFFEF4444), 'cấm'),
  _Cell(Icons.warning_amber_rounded, Color(0xFFF59E0B), 'cảnh báo'),
  _Cell(Icons.info_outline,      Color(0xFF3B82F6), 'thông tin'),
];
const _kParking = [
  _Cell(Icons.local_parking,     Color(0xFF3B82F6), 'chỗ đỗ'),
  _Cell(Icons.garage,            Color(0xFF6366F1), 'nhà xe'),
  _Cell(Icons.ev_station,        Color(0xFF10B981), 'sạc điện'),
];
final _kCategories = <String, List<_Cell>>{
  'đèn giao thông': _kTraffic,
  'xe hơi':         _kCars,
  'xe máy':         _kMotos,
  'biển báo':       _kSigns,
  'bãi đỗ xe':      _kParking,
};
const _kFillers = <_Cell>[
  _Cell(Icons.cloud,             Color(0xFF64748B), 'mây'),
  _Cell(Icons.wb_sunny,          Color(0xFFF59E0B), 'nắng'),
  _Cell(Icons.directions_walk,   Color(0xFF94A3B8), 'người đi bộ'),
  _Cell(Icons.forest,            Color(0xFF10B981), 'cây'),
  _Cell(Icons.house,             Color(0xFF8B5CF6), 'nhà'),
  _Cell(Icons.store,             Color(0xFFF472B6), 'cửa hàng'),
  _Cell(Icons.school,            Color(0xFF06B6D4), 'trường học'),
];

// ============================================================
//  Main widget – checkbox + popup challenge
// ============================================================

/// reCAPTCHA-style widget:
///  • Shows a checkbox row "Tôi không phải robot"
///  • Clicking checkbox opens an image-grid challenge dialog
///  • Clicking "Xác nhận" in the dialog always passes (mock)
///  • [onVerified] fires once the user completes the challenge
class ImageCaptchaWidget extends StatefulWidget {
  final VoidCallback onVerified;
  const ImageCaptchaWidget({super.key, required this.onVerified});

  @override
  State<ImageCaptchaWidget> createState() => _ImageCaptchaWidgetState();
}

class _ImageCaptchaWidgetState extends State<ImageCaptchaWidget> {
  bool _checked = false;   // has the user completed the challenge?
  bool _loading = false;   // spinner while "verifying"

  Future<void> _onCheckboxTap() async {
    if (_checked) return; // already verified – do nothing

    // Open the challenge dialog
    final passed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => const _ChallengeDialog(),
    );

    if (passed == true && mounted) {
      // Simulate a short "verifying…" spinner
      setState(() => _loading = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        _loading = false;
        _checked = true;
      });
      widget.onVerified();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          // ── Checkbox ────────────────────────────────────────
          GestureDetector(
            onTap: _onCheckboxTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: _checked
                    ? const Color(0xFF10B981)
                    : const Color(0xFF0F172A),
                border: Border.all(
                  color: _checked
                      ? const Color(0xFF10B981)
                      : const Color(0xFF475569),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(4),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : _checked
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
            ),
          ),
          const SizedBox(width: 14),

          // ── Label ───────────────────────────────────────────
          Text(
            'Tôi không phải robot',
            style: TextStyle(
              color: _checked
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          // ── reCAPTCHA branding ───────────────────────────────
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user, color: Color(0xFF4285F4), size: 22),
              SizedBox(height: 2),
              Text(
                'reCAPTCHA',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'Bảo vệ',
                style: TextStyle(color: Color(0xFF475569), fontSize: 7),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

// ============================================================
//  Challenge dialog – 3×3 image grid
// ============================================================
class _ChallengeDialog extends StatefulWidget {
  const _ChallengeDialog();

  @override
  State<_ChallengeDialog> createState() => _ChallengeDialogState();
}

class _ChallengeDialogState extends State<_ChallengeDialog> {
  late String _category;
  late List<_Cell> _grid;
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _buildGrid();
  }

  void _buildGrid() {
    final rng = Random();
    final keys = _kCategories.keys.toList()..shuffle(rng);
    _category = keys.first;

    final targets = List<_Cell>.from(_kCategories[_category]!);
    final fillers = List<_Cell>.from(_kFillers)..shuffle(rng);

    final count = 2 + rng.nextInt(2); // 2 or 3 target cells
    final chosen = targets.take(count).toList();
    final grid = [...chosen, ...fillers.take(9 - count)]..shuffle(rng);

    setState(() {
      _grid = grid;
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Constrain dialog width
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildGrid3x3(),
              _buildDialogFooter(),
            ],
          ),
        ).animate().fadeIn(duration: 200.ms).scale(
              begin: const Offset(0.92, 0.92),
              duration: const Duration(milliseconds: 200),
            ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────
  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF162032),
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      child: Row(
        children: [
          const Icon(Icons.security, color: Color(0xFF60A5FA), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn tất cả hình ảnh có chứa',
                  style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                ),
                Text(
                  _category.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFF60A5FA), size: 20),
            onPressed: _buildGrid,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  // ── 3×3 Grid ─────────────────────────────────────────────
  Widget _buildGrid3x3() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemCount: 9,
        itemBuilder: (_, i) => _GridCell(
          cell: _grid[i],
          selected: _selected.contains(i),
          onTap: () => setState(() {
            _selected.contains(i)
                ? _selected.remove(i)
                : _selected.add(i);
          }),
        ),
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────
  Widget _buildDialogFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF162032),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user,
              color: Color(0xFF4285F4), size: 16),
          const SizedBox(width: 6),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('reCAPTCHA',
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9,
                      fontWeight: FontWeight.w600)),
              Text('Bảo vệ · Quyền riêng tư',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 7)),
            ],
          ),
          const Spacer(),
          // Skip button
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Bỏ qua',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          ),
          const SizedBox(width: 6),
          // Confirm button – always passes
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285F4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Xác nhận',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  Single grid cell
// ============================================================
class _GridCell extends StatelessWidget {
  final _Cell cell;
  final bool selected;
  final VoidCallback onTap;
  const _GridCell({required this.cell, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        decoration: BoxDecoration(
          color: selected
              ? cell.color.withValues(alpha: 0.22)
              : const Color(0xFF0F172A),
          border: Border.all(
            color: selected ? cell.color : Colors.transparent,
            width: selected ? 3 : 0,
          ),
        ),
        child: Stack(
          children: [
            // Noise background
            CustomPaint(
              painter: _NoisePainter(seed: cell.icon.codePoint % 31),
              child: const SizedBox.expand(),
            ),
            // Icon + label
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cell.icon, color: cell.color, size: 34),
                  const SizedBox(height: 3),
                  Text(
                    cell.label,
                    style: TextStyle(
                      color: cell.color.withValues(alpha: 0.85),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Selection tick
            if (selected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: cell.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  Noise background painter
// ============================================================
class _NoisePainter extends CustomPainter {
  final int seed;
  const _NoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(seed);
    final paint = Paint();
    const shades = [Color(0xFF1A2535), Color(0xFF1E2D42), Color(0xFF162030)];
    paint.color = shades[seed % shades.length];
    canvas.drawRect(Offset.zero & size, paint);

    for (int i = 0; i < 30; i++) {
      paint.color =
          Colors.white.withValues(alpha: rng.nextDouble() * 0.04);
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        rng.nextDouble() * 2.5 + 0.5,
        paint,
      );
    }
    paint.color = Colors.white.withValues(alpha: 0.03);
    paint.strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => old.seed != seed;
}
