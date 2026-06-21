import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/utils/responsive.dart';
import 'dart:ui';

class LandingHero extends StatelessWidget {
  final VoidCallback? onExplorePressed;
  const LandingHero({super.key, this.onExplorePressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Orbs
          Positioned(
            top: -100,
            left: -100,
            child: _buildOrb(const Color(0xFF7C3AED).withValues(alpha: 0.17), 600)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: 0, end: -0.05, duration: 4.seconds, curve: Curves.easeInOut),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildOrb(const Color(0xFF06B6D4).withValues(alpha: 0.12), 500)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: 0, end: -0.05, duration: 5.seconds, curve: Curves.easeInOut),
          ),

          // Content
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Copy
              Expanded(
                flex: isMobile ? 0 : 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.28)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFA78BFA),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Color(0xFFA78BFA), blurRadius: 8)
                              ],
                            ),
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1.0, end: 0.7, duration: 1200.ms),
                          const SizedBox(width: 8),
                          const Text(
                            'Đồ án SU26SWP08  ·  Flutter & Dart',
                            style: TextStyle(
                              color: Color(0xFFA78BFA),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                    const SizedBox(height: 24),
                    // H1
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: clampDouble(size.width * 0.05, 44, 72),
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: -1.5,
                              color: const Color(0xFFF0F4FC),
                            ),
                        children: const [
                          TextSpan(text: 'Bãi xe thông minh\n'),
                          TextSpan(
                            text: 'không còn\n',
                            style: TextStyle(color: Color(0xFF67E8F9)), // Gradient approximation
                          ),
                          TextSpan(text: 'mất kiểm soát'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    // Subtitle
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 17, height: 1.8, color: Color(0xFF8492A6)),
                        children: [
                          TextSpan(text: 'ParkSmart kết nối quản lý slot real-time, check-in/out tức thì, đặt chỗ trước và báo cáo doanh thu — trong '),
                          TextSpan(text: 'một nền tảng thống nhất', style: TextStyle(color: Color(0xFFF0F4FC), fontWeight: FontWeight.w600)),
                          TextSpan(text: ' dành cho 4 vai trò người dùng.'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const SizedBox(height: 40),
                    // Buttons
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (onExplorePressed != null) {
                              onExplorePressed!();
                            } else {
                              context.go('/login');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 8,
                            shadowColor: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Khám phá tính năng', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
                            backgroundColor: Colors.transparent,
                          ),
                          child: const Text('Xem cách hoạt động', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF8492A6))),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),
                    const SizedBox(height: 52),
                    // Stats
                    _buildStatsRow(isMobile).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),
              if (isMobile) const SizedBox(height: 60) else const SizedBox(width: 40),
              // Right: Mockup
              Expanded(
                flex: isMobile ? 0 : 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 10),
                  child: _buildMockupVisual(isMobile)
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .scaleXY(begin: 0.9, end: 1.0, curve: Curves.easeOutBack),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    ).animate().custom(
          duration: 0.ms,
          builder: (context, value, child) => ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: child,
          ),
        );
  }

  Widget _buildStatsRow(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 24 : 32,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _statItem('190', 'ô đỗ xe', false),
        _statDivider(),
        _statItem('4', 'tầng xe', false),
        _statDivider(),
        _statItem('4', 'vai trò', false),
        _statDivider(),
        _statItem('Live', 'trạng thái', true),
      ],
    );
  }

  Widget _statDivider() => Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.07));

  Widget _statItem(String value, String label, bool isLive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: isLive ? const Color(0xFF6EE7B7) : const Color(0xFFF0F4FC), height: 1.1)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF8492A6))),
      ],
    );
  }

  Widget _buildMockupVisual(bool isMobile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(-0.05)
            ..rotateX(0.02),
          alignment: FractionalOffset.center,
          child: Container(
            height: isMobile ? 320 : 420,
            decoration: BoxDecoration(
              color: const Color(0xFF0C1120).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: const [
                BoxShadow(color: Colors.black45, blurRadius: 40, offset: Offset(0, 12)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Column(
                  children: [
                    // Chrome Bar
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
                      ),
                      child: Row(
                        children: [
                          _dot(const Color(0xFFFB7185)),
                          const SizedBox(width: 6),
                          _dot(const Color(0xFFFBBF24)),
                          const SizedBox(width: 6),
                          _dot(const Color(0xFF10B981)),
                          const SizedBox(width: 10),
                          const Icon(Icons.apps, size: 10, color: Color(0xFF4E5D72)),
                          const SizedBox(width: 4),
                          const Text('ParkSmart — Quản lý tầng 1', style: TextStyle(fontSize: 10, color: Color(0xFF4E5D72))),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                                ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 1.seconds),
                                const SizedBox(width: 4),
                                const Text('Live', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF6EE7B7))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stats bar
                    Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07)))),
                      child: Row(
                        children: [
                          Expanded(child: _dsCard('Slot trống', '86', '+12 hôm nay', const Color(0xFF10B981))),
                          Expanded(child: _dsCard('Đang dùng', '74', '46% công suất', const Color(0xFFF43F5E))),
                          Expanded(child: _dsCard('Doanh thu', '2.4M', 'hôm nay', const Color(0xFF7C3AED))),
                          Expanded(child: _dsCard('Lượt xe', '128', 'hôm nay', const Color(0xFF06B6D4), noBorder: true)),
                        ],
                      ),
                    ),
                    // Slot grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tầng 1 — Xe máy', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF67E8F9))),
                            const SizedBox(height: 10),
                            Expanded(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 2.0,
                                ),
                                itemCount: 15,
                                itemBuilder: (context, i) {
                                  final isOccupied = i % 4 == 1 || i % 6 == 3;
                                  final isReserved = i == 7 || i == 14;
                                  Color color = const Color(0xFF6EE7B7);
                                  Color bg = const Color(0xFF10B981).withValues(alpha: 0.12);
                                  if (isOccupied) {
                                    color = const Color(0xFFFB7185);
                                    bg = const Color(0xFFF43F5E).withValues(alpha: 0.12);
                                  } else if (isReserved) {
                                    color = const Color(0xFFFBBF24);
                                    bg = const Color(0xFFFBBF24).withValues(alpha: 0.12);
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: bg,
                                      border: Border.all(color: color.withValues(alpha: 0.25)),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('A0${i + 1}', style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.w700)),
                                  ).animate().fadeIn(delay: (i * 40).ms);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Floating badges
        Positioned(
          bottom: 0,
          left: -10,
          child: _fBadge('Check-in thành công', Icons.check, const Color(0xFF6EE7B7), const Color(0xFF10B981))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .slideY(begin: 0, end: -0.15, duration: 2.seconds, curve: Curves.easeInOut),
        ),
        Positioned(
          top: -20,
          right: -10,
          child: _fBadge('Doanh thu +18%', Icons.trending_up, const Color(0xFFA78BFA), const Color(0xFF7C3AED))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .slideY(begin: 0, end: -0.15, duration: 2.seconds, curve: Curves.easeInOut, delay: 1.seconds),
        ),
      ],
    );
  }

  Widget _dot(Color color) => Container(width: 9, height: 9, decoration: BoxDecoration(shape: BoxShape.circle, color: color));

  Widget _dsCard(String title, String value, String sub, Color color, {bool noBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: noBorder ? null : Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: Stack(
        children: [
          Positioned(top: -14, left: -16, right: -16, child: Container(height: 2, color: color)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 8, color: Color(0xFF8492A6))),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1)),
              const SizedBox(height: 4),
              Text(sub, style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fBadge(String text, IconData icon, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.18),
        border: Border.all(color: bgColor.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: textColor),
              const SizedBox(width: 7),
              Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
