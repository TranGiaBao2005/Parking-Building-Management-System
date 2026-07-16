import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/parking_brand_logo.dart';

const _landingBg = Color(0xFF070A13);
const _landingText = Color(0xFFF5F7FB);
const _landingMuted = Color(0xFF97A1B5);
const _landingPurple = Color(0xFF7C3AED);
const _landingCyan = Color(0xFF06B6D4);
const _landingGreen = Color(0xFF34D399);
const _landingBorder = Color(0xFF252B3A);

// ──────────────────────────────────────────────
// Shared Navbar widget dùng lại ở cả 3 trang
// ──────────────────────────────────────────────
class LandingNavbar extends StatelessWidget {
  final String activePage; // 'home' | 'search' | 'chat'
  final VoidCallback onLogin;

  const LandingNavbar({
    super.key,
    required this.activePage,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 780;
        return Container(
          height: 74,
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 36),
          decoration: BoxDecoration(
            color: _landingBg.withValues(alpha: 0.96),
            border: const Border(bottom: BorderSide(color: _landingBorder)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.go('/'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ParkingBrandLogo(size: 40),
                        SizedBox(width: 11),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ParkSmart',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'SWP08',
                              style: TextStyle(
                                  color: Color(0xFF70E5F5),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!compact) ...[
                    _NavTabButton(
                      label: 'Trang chủ',
                      icon: Icons.home_outlined,
                      active: activePage == 'home',
                      onTap: () => context.go('/'),
                    ),
                    _NavTabButton(
                      label: 'Tìm kiếm',
                      icon: Icons.map_outlined,
                      active: activePage == 'search',
                      onTap: () => context.go('/search'),
                    ),
                    _NavTabButton(
                      label: 'Chatbot',
                      icon: Icons.smart_toy_outlined,
                      active: activePage == 'chat',
                      onTap: () => context.go('/chat'),
                    ),
                  ] else ...[
                    // Mobile: icon buttons
                    IconButton(
                      icon: Icon(
                        Icons.home_rounded,
                        color: activePage == 'home' ? _landingCyan : _landingMuted,
                      ),
                      onPressed: () => context.go('/'),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.map_rounded,
                        color: activePage == 'search' ? _landingCyan : _landingMuted,
                      ),
                      onPressed: () => context.go('/search'),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.smart_toy_rounded,
                        color: activePage == 'chat' ? _landingCyan : _landingMuted,
                      ),
                      onPressed: () => context.go('/chat'),
                    ),
                  ],
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _landingPurple,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: compact ? 13 : 18, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11)),
                    ),
                    icon: const Icon(Icons.login_rounded, size: 16),
                    label: Text(compact ? 'Đăng nhập' : 'Bắt đầu gửi xe'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: active ? _landingCyan.withValues(alpha: 0.1) : Colors.transparent,
      ),
      icon: Icon(
        icon,
        color: active ? _landingCyan : _landingMuted,
        size: 16,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: active ? _landingCyan : _landingMuted,
          fontSize: 13,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Landing Screen (Trang chủ - "home")
// ──────────────────────────────────────────────
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _landingBg,
      body: SelectionArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 74),
                  _LandingHero(onExplore: () => context.go('/search')),
                  const _StatsSection(),
                  const _BenefitsSection(),
                  const _HowItWorksSection(),
                  const _TestimonialsSection(),
                  const _FaqSection(),
                  _CustomerCta(onLogin: () => context.go('/login')),
                  const _LandingFooter(),
                ],
              ),
            ),
            Positioned(
              top: 0, left: 0, right: 0,
              child: LandingNavbar(
                activePage: 'home',
                onLogin: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingHero extends StatelessWidget {
  final VoidCallback onExplore;
  const _LandingHero({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return _LandingWidth(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 820;
          final copy = Column(
            crossAxisAlignment:
                compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              const _Eyebrow('GIẢI PHÁP DÀNH CHO NGƯỜI GỬI XE'),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [_landingText, Color(0xFF70E5F5)],
                ).createShader(bounds),
                child: Text(
                  'Chỗ đậu phù hợp,\nhành trình chủ động.',
                  textAlign: compact ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 43 : 62,
                    height: 1.04,
                    letterSpacing: -2.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Text(
                  'ParkSmart giúp bạn xem chỗ trống, đặt trước vị trí, vào bãi bằng biển số và theo dõi lượt gửi xe trong một trải nghiệm đơn giản, minh bạch.',
                  textAlign: compact ? TextAlign.center : TextAlign.left,
                  style: const TextStyle(
                      color: _landingMuted, fontSize: 16, height: 1.7),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment:
                    compact ? WrapAlignment.center : WrapAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _landingPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 17),
                    ),
                    icon: const Icon(Icons.map_rounded, size: 18),
                    label: const Text('Tìm bãi đỗ gần tôi'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/login'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _landingText,
                      side: const BorderSide(color: _landingBorder),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 17),
                    ),
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Đăng ký tài khoản'),
                  ),
                ],
              ),
              const SizedBox(height: 38),
              const Wrap(
                spacing: 28,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: [
                  _TrustMetric(value: '24/7', label: 'Theo dõi lượt gửi'),
                  _TrustMetric(value: '4 bước', label: 'Đặt chỗ đơn giản'),
                  _TrustMetric(value: 'Minh bạch', label: 'Thời gian & chi phí'),
                ],
              ),
            ],
          );

          return Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 58 : 80),
            child: compact
                ? Column(children: [
                    copy,
                    const SizedBox(height: 48),
                    const _CustomerPhonePreview(),
                  ])
                : Row(children: [
                    Expanded(flex: 6, child: copy),
                    const SizedBox(width: 54),
                    const Expanded(flex: 4, child: _CustomerPhonePreview()),
                  ]),
          );
        },
      ),
    );
  }
}

class _CustomerPhonePreview extends StatelessWidget {
  const _CustomerPhonePreview();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 370),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF171F33), Color(0xFF0B101D)],
          ),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFF30384A)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000),
                blurRadius: 55,
                offset: Offset(0, 25)),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('9:41',
                    style: TextStyle(color: Colors.white70, fontSize: 9)),
                Container(
                  width: 74, height: 19,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                ),
                const Text('•••',
                    style: TextStyle(color: Colors.white70, fontSize: 9)),
              ],
            ),
            const SizedBox(height: 18),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Xin chào, Minh Anh',
                          style:
                              TextStyle(color: _landingMuted, fontSize: 10)),
                      SizedBox(height: 3),
                      Text('Tìm chỗ đậu xe',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                ParkingBrandLogo(size: 44),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: _landingGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: _landingGreen.withValues(alpha: 0.24)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.circle, color: _landingGreen, size: 8),
                    SizedBox(width: 7),
                    Text('BÃI XE SWP08',
                        style: TextStyle(
                            color: _landingMuted,
                            fontSize: 8,
                            letterSpacing: 1.2)),
                  ]),
                  SizedBox(height: 8),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '86 ',
                        style: TextStyle(
                            color: _landingGreen,
                            fontSize: 29,
                            fontWeight: FontWeight.w800)),
                    TextSpan(
                        text: 'slot trống',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 11)),
                  ])),
                  Text('Cập nhật ngay lúc này',
                      style: TextStyle(color: _landingMuted, fontSize: 8)),
                ],
              ),
            ),
            const SizedBox(height: 17),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chọn loại phương tiện',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
                Text('Xem tất cả',
                    style: TextStyle(color: Color(0xFF70E5F5), fontSize: 8)),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Expanded(
                    child: _VehicleChoice(
                        emoji: '🚗',
                        label: 'Ô tô',
                        count: '42 chỗ',
                        selected: true)),
                SizedBox(width: 8),
                Expanded(
                    child: _VehicleChoice(
                        emoji: '🛵', label: 'Xe máy', count: '38 chỗ')),
                SizedBox(width: 8),
                Expanded(
                    child: _VehicleChoice(
                        emoji: '🚚', label: 'Xe tải', count: '6 chỗ')),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_landingPurple, _landingCyan]),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Text('Đặt chỗ ngay  →',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleChoice extends StatelessWidget {
  final String emoji;
  final String label;
  final String count;
  final bool selected;

  const _VehicleChoice({
    required this.emoji,
    required this.label,
    required this.count,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        color: selected
            ? _landingPurple.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
            color: selected
                ? _landingPurple.withValues(alpha: 0.55)
                : _landingBorder),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(count,
              style: const TextStyle(color: _landingMuted, fontSize: 7)),
        ],
      ),
    );
  }
}

class _CustomerCta extends StatelessWidget {
  final VoidCallback onLogin;
  const _CustomerCta({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return _LandingWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 75),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(compact ? 26 : 35),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  _landingPurple.withValues(alpha: 0.18),
                  _landingCyan.withValues(alpha: 0.08),
                ]),
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                    color: _landingPurple.withValues(alpha: 0.42)),
              ),
              child: compact
                  ? Column(children: [
                      const ParkingBrandLogo(size: 65),
                      const SizedBox(height: 20),
                      const _CtaCopy(centered: true),
                      const SizedBox(height: 22),
                      _CtaButton(onPressed: onLogin),
                    ])
                  : Row(children: [
                      const ParkingBrandLogo(size: 68),
                      const SizedBox(width: 24),
                      const Expanded(child: _CtaCopy()),
                      const SizedBox(width: 24),
                      _CtaButton(onPressed: onLogin),
                    ]),
            );
          },
        ),
      ),
    );
  }
}

class _CtaCopy extends StatelessWidget {
  final bool centered;
  const _CtaCopy({this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        const Text('PARKSMART SWP08',
            style: TextStyle(
                color: Color(0xFF70E5F5),
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5)),
        const SizedBox(height: 6),
        Text('Chủ động chỗ đậu cho hành trình tiếp theo.',
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
            'Đăng ký tài khoản và trải nghiệm quy trình gửi xe đơn giản hơn.',
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(color: _landingMuted, fontSize: 11)),
      ],
    );
  }
}

class _CtaButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CtaButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _landingPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      ),
      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
      label: const Text('Bắt đầu ngay'),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  const _LandingFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: _landingBorder))),
      child: _LandingWidth(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 650;
              const brand = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ParkingBrandLogo(size: 35),
                  SizedBox(width: 10),
                  Text('ParkSmart SWP08',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              );
              const copy = Text(
                  'Trải nghiệm gửi xe thông minh dành cho khách hàng.',
                  style: TextStyle(color: _landingMuted, fontSize: 10));
              const copyright = Text('© 2026 ParkSmart SWP08',
                  style:
                      TextStyle(color: Color(0xFF697386), fontSize: 10));
              return compact
                  ? const Column(children: [
                      brand,
                      SizedBox(height: 12),
                      copy,
                      SizedBox(height: 8),
                      copyright,
                    ])
                  : const Row(children: [
                      brand,
                      Spacer(),
                      copy,
                      SizedBox(width: 28),
                      copyright,
                    ]);
            },
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shared layout helpers
// ──────────────────────────────────────────────
class _LandingWidth extends StatelessWidget {
  final Widget child;
  const _LandingWidth({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: child,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Stats Section
// ──────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('500+', 'Lượt gửi xe\nmỗi ngày', Icons.directions_car_rounded, _landingCyan),
      ('86', 'Chỗ trống\nhiện tại', Icons.local_parking_rounded, _landingGreen),
      ('4 tầng', 'Khu vực\ngửi xe riêng', Icons.layers_rounded, _landingPurple),
      ('24/7', 'Theo dõi\nlượt gửi', Icons.access_time_rounded, Color(0xFFFBBF24)),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _landingPurple.withValues(alpha: 0.07),
            _landingCyan.withValues(alpha: 0.04),
          ],
        ),
        border: const Border.symmetric(
          horizontal: BorderSide(color: _landingBorder),
        ),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (ctx, c) {
            final cols = c.maxWidth < 600 ? 2 : 4;
            final w = (c.maxWidth - (cols - 1) * 16) / cols;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: stats.map((s) => SizedBox(
                width: w,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: s.$4.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: s.$4.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: s.$4.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(s.$3, color: s.$4, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1, style: TextStyle(color: s.$4, fontSize: 24, fontWeight: FontWeight.w800)),
                          Text(s.$2, style: const TextStyle(color: _landingMuted, fontSize: 11, height: 1.4)),
                        ],
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Benefits Section
// ──────────────────────────────────────────────
class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection();

  static const _benefits = [
    (
      Icons.location_searching_rounded,
      'Biết chỗ trống trước',
      'Kiểm tra tình trạng bãi và chọn thời gian phù hợp trước khi bắt đầu hành trình. Không còn cảnh lái vòng vòng tìm chỗ.',
      Color(0xFFA78BFA),
    ),
    (
      Icons.event_available_rounded,
      'Đặt chỗ trực tuyến',
      'Chọn loại xe, thời gian và khu vực mong muốn chỉ trong vài thao tác. Hệ thống tự động phân bổ vị trí tối ưu cho bạn.',
      Color(0xFF67E8F9),
    ),
    (
      Icons.qr_code_scanner_rounded,
      'Vào bãi nhanh bằng QR',
      'Mã QR được tạo sau khi đặt chỗ. Nhân viên quét mã và bạn vào bãi ngay — không cần điền giấy tờ hay chờ đợi.',
      Color(0xFF6EE7B7),
    ),
    (
      Icons.schedule_rounded,
      'Theo dõi lượt gửi 24/7',
      'Xem giờ vào, vị trí slot và trạng thái phương tiện bất cứ lúc nào, ngay từ điện thoại của bạn.',
      Color(0xFFFDBA74),
    ),
    (
      Icons.payments_outlined,
      'Chi phí minh bạch',
      'Bảng giá rõ ràng theo từng loại xe và khung giờ. Không có phụ phí ẩn. Thời gian gửi được tính chính xác đến phút.',
      Color(0xFFF9A8D4),
    ),
    (
      Icons.smart_toy_rounded,
      'Trợ lý AI 24/7',
      'Chatbot AI sẵn sàng giải đáp mọi thắc mắc về giá cả, chỗ trống, và quy trình gửi xe bất cứ lúc nào bạn cần.',
      Color(0xFF93C5FD),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _landingBorder)),
      ),
      child: _LandingWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LandingSectionHeading(
              eyebrow: 'LỢI ÍCH CHO KHÁCH HÀNG',
              title: 'Gửi xe nhẹ nhàng hơn\ntừ trước khi bạn đến',
              description: 'Mọi tính năng được thiết kế xoay quanh sự chủ động và an tâm của người gửi xe.',
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (ctx, c) {
                final cols = c.maxWidth >= 900 ? 3 : c.maxWidth >= 600 ? 2 : 1;
                final w = (c.maxWidth - (cols - 1) * 16) / cols;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _benefits.map((b) => SizedBox(
                    width: w,
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101728),
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: _landingBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(
                              color: b.$4.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(b.$1, color: b.$4, size: 24),
                          ),
                          const SizedBox(height: 20),
                          Text(b.$2, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          Text(b.$3, style: const TextStyle(color: _landingMuted, fontSize: 13, height: 1.65)),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// How It Works Section
// ──────────────────────────────────────────────
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  static const _steps = [
    (
      '01',
      Icons.person_add_alt_1_rounded,
      'Đăng ký tài khoản',
      'Nhập thông tin cơ bản và biển số phương tiện. Chỉ mất dưới 2 phút để hoàn tất đăng ký.',
      _landingCyan,
    ),
    (
      '02',
      Icons.bookmark_add_rounded,
      'Đặt chỗ trước',
      'Chọn loại xe, tầng và khung giờ mong muốn. Hệ thống phân bổ slot và tạo mã QR cho bạn ngay lập tức.',
      _landingPurple,
    ),
    (
      '03',
      Icons.qr_code_rounded,
      'Đưa xe đến bãi',
      'Nhân viên quét mã QR trên điện thoại — bạn vào bãi nhanh chóng mà không cần xếp hàng hay điền phiếu.',
      _landingGreen,
    ),
    (
      '04',
      Icons.check_circle_rounded,
      'Nhận xe & hoàn tất',
      'Xem chi phí chính xác dựa trên thời gian thực tế. Lịch sử lượt gửi được lưu đầy đủ trong tài khoản.',
      Color(0xFFFBBF24),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1020),
        border: Border.symmetric(horizontal: BorderSide(color: _landingBorder)),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (ctx, c) {
            final compact = c.maxWidth < 780;
            const heading = _LandingSectionHeading(
              eyebrow: 'CHỈ VỚI 4 BƯỚC ĐƠN GIẢN',
              title: 'Quy trình gửi xe\nkhông còn phức tạp',
              description: 'ParkSmart được thiết kế để khách hàng có thể sử dụng ngay từ lần đầu tiên, không cần hướng dẫn.',
            );
            final steps = Column(
              children: _steps.asMap().entries.map((e) {
                final s = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _landingBg.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: s.$5.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: s.$5.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(s.$2, color: s.$5, size: 24),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(s.$1, style: TextStyle(color: s.$5, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                                const SizedBox(width: 8),
                                Text(s.$3, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(s.$4, style: const TextStyle(color: _landingMuted, fontSize: 13, height: 1.55)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
            return compact
                ? Column(children: [heading, const SizedBox(height: 40), steps])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: heading),
                      const SizedBox(width: 70),
                      Expanded(flex: 6, child: steps),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Testimonials Section
// ──────────────────────────────────────────────
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  static const _quotes = [
    (
      '"Từ khi dùng ParkSmart tôi không còn lo lắng mỗi khi đi làm qua Q.7. Biết chỗ trước, vào nhanh, chi phí rõ ràng — không có gì để phàn nàn."',
      'Minh Anh, 29 tuổi',
      'Khách gửi xe ô tô thường xuyên',
      'MA',
      _landingCyan,
    ),
    (
      '"Tôi thích nhất là cái mã QR. Hồi trước mỗi lần vào bãi phải chờ 5–7 phút. Giờ chỉ cần quét là xong, cực kỳ tiện."',
      'Quốc Huy, 34 tuổi',
      'Tài xế giao hàng',
      'QH',
      _landingPurple,
    ),
    (
      '"App đơn giản, dễ dùng. Phần hỏi đáp AI giúp tôi biết giá và còn chỗ mà không cần gọi điện hỏi như trước nữa."',
      'Thu Trang, 26 tuổi',
      'Nhân viên văn phòng',
      'TT',
      _landingGreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: const Color(0xFF090D18),
      child: _LandingWidth(
        child: Column(
          children: [
            const _LandingSectionHeading(
              eyebrow: 'KHÁCH HÀNG NÓI GÌ',
              title: 'Trải nghiệm thực tế\ntừ người dùng ParkSmart',
              centered: true,
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (ctx, c) {
                final cols = c.maxWidth >= 850 ? 3 : 1;
                final w = (c.maxWidth - (cols - 1) * 16) / cols;
                return Wrap(
                  spacing: 16, runSpacing: 16,
                  children: _quotes.map((q) => SizedBox(
                    width: w,
                    child: Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101728),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: q.$5.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.format_quote_rounded, color: q.$5, size: 28),
                          const SizedBox(height: 14),
                          Text(q.$1, style: const TextStyle(color: Color(0xFFD8DEEA), fontSize: 13, height: 1.75)),
                          const SizedBox(height: 22),
                          const Divider(color: _landingBorder),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: q.$5.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(q.$4, style: TextStyle(color: q.$5, fontSize: 12, fontWeight: FontWeight.w800)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(q.$2, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                                  Text(q.$3, style: const TextStyle(color: _landingMuted, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// FAQ Section
// ──────────────────────────────────────────────
class _FaqSection extends StatelessWidget {
  const _FaqSection();

  static const _faqs = [
    (
      'Tôi có cần đặt chỗ trước không?',
      'Không bắt buộc. Bạn có thể đến trực tiếp nếu còn chỗ. Tuy nhiên, đặt trước giúp bạn chủ động hơn, tránh tình trạng đầy bãi vào giờ cao điểm và được ưu tiên vị trí tốt.',
    ),
    (
      'Bảng giá gửi xe như thế nào?',
      'Giá áp dụng theo giờ: Xe máy 5.000đ/giờ · Ô tô 15.000đ/giờ · Xe tải 25.000đ/giờ. Gửi qua đêm giảm 20%. Đăng ký gói tháng để được giá ưu đãi hơn nữa.',
    ),
    (
      'Tôi xem vị trí xe của mình ở đâu?',
      'Sau khi check-in, vị trí tầng và mã slot được hiển thị ngay trong mục "Lượt gửi của tôi". Bạn cũng nhận được thông báo xác nhận qua app.',
    ),
    (
      'Ứng dụng hỗ trợ những loại xe nào?',
      'ParkSmart hỗ trợ 3 loại phương tiện: Xe máy (Tầng 1–2), Ô tô (Tầng 3–4) và Xe tải (khu vực riêng tầng trệt). Mỗi khu vực được thiết kế phù hợp với kích thước phương tiện.',
    ),
    (
      'Nếu tôi vào trễ hơn giờ đặt chỗ thì sao?',
      'Slot được giữ trong vòng 30 phút kể từ giờ đặt. Nếu bạn trễ hơn, slot có thể được cấp lại. Bạn nên liên hệ nhân viên hoặc hỏi chatbot AI để xử lý trực tiếp.',
    ),
    (
      'Tôi có thể gửi phản hồi hay khiếu nại ở đâu?',
      'Bạn có thể gửi phản hồi trực tiếp trong tab "Phản hồi" sau khi đăng nhập. Đội ngũ hỗ trợ sẽ xem xét và phản hồi trong vòng 24 giờ làm việc.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        color: Color(0xFF101728),
        border: Border.symmetric(horizontal: BorderSide(color: _landingBorder)),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (ctx, c) {
            final compact = c.maxWidth < 760;
            const heading = _LandingSectionHeading(
              eyebrow: 'HỎI ĐÁP THƯỜNG GẶP',
              title: 'Câu hỏi bạn\ncó thể cần biết',
              description: 'Tổng hợp những thắc mắc phổ biến nhất từ khách hàng trước khi bắt đầu sử dụng ParkSmart.',
            );
            final list = Column(
              children: _faqs.map((f) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: _landingBg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _landingBorder),
                ),
                child: ExpansionTile(
                  iconColor: _landingCyan,
                  collapsedIconColor: _landingMuted,
                  title: Text(f.$1, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(f.$2, style: const TextStyle(color: _landingMuted, fontSize: 13, height: 1.65)),
                    ),
                  ],
                ),
              )).toList(),
            );
            return compact
                ? Column(children: [heading, const SizedBox(height: 40), list])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: heading),
                      const SizedBox(width: 70),
                      Expanded(flex: 6, child: list),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Shared Section Heading for Landing
// ──────────────────────────────────────────────
class _LandingSectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? description;
  final bool centered;

  const _LandingSectionHeading({
    required this.eyebrow,
    required this.title,
    this.description,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Color(0xFFB6A0FF),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            height: 1.12,
            letterSpacing: -1.3,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 14),
          Text(
            description!,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(color: _landingMuted, fontSize: 14, height: 1.7),
          ),
        ],
      ],
    );
  }
}


class _Eyebrow extends StatelessWidget {
  final String text;
  const _Eyebrow(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 2, color: _landingCyan),
        const SizedBox(width: 9),
        Flexible(
          child: Text(text,
              style: const TextStyle(
                  color: Color(0xFFB6A0FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4)),
        ),
      ],
    );
  }
}

class _TrustMetric extends StatelessWidget {
  final String value;
  final String label;
  const _TrustMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(label,
            style:
                const TextStyle(color: _landingMuted, fontSize: 10)),
      ],
    );
  }
}
