import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/parking_brand_logo.dart';

const _landingBg = Color(0xFF070A13);
const _landingSurface = Color(0xFF101728);
const _landingText = Color(0xFFF5F7FB);
const _landingMuted = Color(0xFF97A1B5);
const _landingPurple = Color(0xFF7C3AED);
const _landingCyan = Color(0xFF06B6D4);
const _landingGreen = Color(0xFF34D399);
const _landingBorder = Color(0xFF252B3A);

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _benefitsKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _safetyKey = GlobalKey();
  final _faqKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.02,
    );
  }

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
                  _LandingHero(onExplore: () => _scrollTo(_stepsKey)),
                  Container(
                    key: _benefitsKey,
                    child: const _CustomerBenefits(),
                  ),
                  Container(key: _stepsKey, child: const _CustomerSteps()),
                  Container(key: _safetyKey, child: const _CustomerSafety()),
                  const _CustomerTestimonials(),
                  Container(key: _faqKey, child: const _CustomerFaq()),
                  _CustomerCta(onLogin: () => context.go('/login')),
                  const _LandingFooter(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _LandingNavbar(
                onBenefits: () => _scrollTo(_benefitsKey),
                onSteps: () => _scrollTo(_stepsKey),
                onSafety: () => _scrollTo(_safetyKey),
                onFaq: () => _scrollTo(_faqKey),
                onLogin: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandingNavbar extends StatelessWidget {
  final VoidCallback onBenefits;
  final VoidCallback onSteps;
  final VoidCallback onSafety;
  final VoidCallback onFaq;
  final VoidCallback onLogin;

  const _LandingNavbar({
    required this.onBenefits,
    required this.onSteps,
    required this.onSafety,
    required this.onFaq,
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
            color: _landingBg.withValues(alpha: 0.94),
            border: const Border(
              bottom: BorderSide(color: _landingBorder),
            ),
          ),
          child: Row(
            children: [
              const ParkingBrandLogo(size: 40),
              const SizedBox(width: 11),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ParkSmart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'SWP08',
                    style: TextStyle(
                      color: Color(0xFF70E5F5),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (!compact) ...[
                _NavLink(label: 'Lợi ích', onPressed: onBenefits),
                _NavLink(label: 'Cách gửi xe', onPressed: onSteps),
                _NavLink(label: 'An toàn', onPressed: onSafety),
                _NavLink(label: 'Hỏi đáp', onPressed: onFaq),
                const SizedBox(width: 16),
              ],
              ElevatedButton.icon(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _landingPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 13 : 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                icon: const Icon(Icons.login_rounded, size: 16),
                label: Text(compact ? 'Đăng nhập' : 'Bắt đầu gửi xe'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NavLink({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: _landingMuted, fontSize: 13),
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
                    color: _landingMuted,
                    fontSize: 16,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: compact ? WrapAlignment.center : WrapAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: onExplore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _landingPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 17,
                      ),
                    ),
                    icon: const Icon(Icons.route_rounded, size: 18),
                    label: const Text('Xem cách sử dụng'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/login'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _landingText,
                      side: const BorderSide(color: _landingBorder),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 17,
                      ),
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
                  _TrustMetric(
                      value: 'Minh bạch', label: 'Thời gian & chi phí'),
                ],
              ),
            ],
          );

          return Padding(
            padding: EdgeInsets.symmetric(vertical: compact ? 58 : 80),
            child: compact
                ? Column(
                    children: [
                      copy,
                      const SizedBox(height: 48),
                      const _CustomerPhonePreview(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 6, child: copy),
                      const SizedBox(width: 54),
                      const Expanded(flex: 4, child: _CustomerPhonePreview()),
                    ],
                  ),
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
              offset: Offset(0, 25),
            ),
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
                  width: 74,
                  height: 19,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                          style: TextStyle(color: _landingMuted, fontSize: 10)),
                      SizedBox(height: 3),
                      Text('Tìm chỗ đậu xe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
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
                border:
                    Border.all(color: _landingGreen.withValues(alpha: 0.24)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, color: _landingGreen, size: 8),
                      SizedBox(width: 7),
                      Text('BÃI XE SWP08',
                          style: TextStyle(
                            color: _landingMuted,
                            fontSize: 8,
                            letterSpacing: 1.2,
                          )),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '86 ',
                          style: TextStyle(
                            color: _landingGreen,
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'slot trống',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
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
                      fontWeight: FontWeight.w600,
                    )),
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
                      selected: true),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _VehicleChoice(
                      emoji: '🛵', label: 'Xe máy', count: '38 chỗ'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _VehicleChoice(
                      emoji: '🚚', label: 'Xe tải', count: '6 chỗ'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_landingPurple, _landingCyan],
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Text('Đặt chỗ ngay  →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  )),
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
              : _landingBorder,
        ),
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

class _CustomerBenefits extends StatelessWidget {
  const _CustomerBenefits();

  @override
  Widget build(BuildContext context) {
    const benefits = [
      (
        Icons.location_searching_rounded,
        'Biết chỗ trống trước',
        'Kiểm tra tình trạng bãi và chọn thời gian phù hợp trước khi bắt đầu hành trình.',
        Color(0xFFA78BFA)
      ),
      (
        Icons.event_available_rounded,
        'Đặt chỗ trực tuyến',
        'Chọn loại xe, thời gian và khu vực mong muốn chỉ trong vài thao tác.',
        Color(0xFF67E8F9)
      ),
      (
        Icons.sensor_occupied_rounded,
        'Vào bãi nhanh',
        'Biển số được nhận diện để giảm thời gian chờ tại cổng.',
        Color(0xFF6EE7B7)
      ),
      (
        Icons.schedule_rounded,
        'Theo dõi lượt gửi',
        'Xem giờ vào, vị trí slot và trạng thái phương tiện bất cứ lúc nào.',
        Color(0xFFFDBA74)
      ),
      (
        Icons.payments_outlined,
        'Chi phí minh bạch',
        'Thời gian gửi và chính sách giá được trình bày rõ ràng.',
        Color(0xFFF9A8D4)
      ),
      (
        Icons.support_agent_rounded,
        'Hỗ trợ thuận tiện',
        'Gửi phản hồi trực tiếp khi cần hỗ trợ về lượt gửi.',
        Color(0xFF93C5FD)
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _landingBorder)),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                    ? 2
                    : 1;
            final cardWidth =
                (constraints.maxWidth - (columns - 1) * 16) / columns;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeading(
                  eyebrow: 'LỢI ÍCH CHO KHÁCH HÀNG',
                  title: 'Gửi xe nhẹ nhàng hơn từ trước khi bạn đến',
                  description:
                      'Mọi tính năng được thiết kế xoay quanh sự chủ động và an tâm của người gửi xe.',
                ),
                const SizedBox(height: 38),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: benefits
                      .map((item) => SizedBox(
                            width: cardWidth,
                            child: _BenefitCard(
                              icon: item.$1,
                              title: item.$2,
                              description: item.$3,
                              color: item.$4,
                            ),
                          ))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _landingSurface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _landingBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 22),
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 9),
          Text(description,
              style: const TextStyle(
                color: _landingMuted,
                fontSize: 13,
                height: 1.65,
              )),
        ],
      ),
    );
  }
}

class _CustomerSteps extends StatelessWidget {
  const _CustomerSteps();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        '01',
        'Đăng ký tài khoản',
        'Nhập thông tin cơ bản và biển số phương tiện để bắt đầu.'
      ),
      (
        '02',
        'Đặt chỗ trước',
        'Chọn loại xe, thời gian dự kiến và gửi yêu cầu đặt chỗ.'
      ),
      (
        '03',
        'Đưa xe đến bãi',
        'Xác nhận nhanh bằng biển số và nhận vị trí slot được phân bổ.'
      ),
      (
        '04',
        'Nhận xe và hoàn tất',
        'Kiểm tra thời gian, chi phí và lịch sử lượt gửi trong tài khoản.'
      ),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1020),
        border: Border.symmetric(
          horizontal: BorderSide(color: _landingBorder),
        ),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 780;
            final heading = const _SectionHeading(
              eyebrow: 'CHỈ VỚI 4 BƯỚC',
              title: 'Một lượt gửi xe không còn phức tạp',
              description:
                  'ParkSmart được thiết kế để khách hàng có thể sử dụng ngay từ lần đầu.',
            );
            final list = Column(
              children: steps
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _StepCard(
                            number: item.$1,
                            title: item.$2,
                            description: item.$3),
                      ))
                  .toList(),
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

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _landingBg.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _landingBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43,
            height: 43,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _landingCyan.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Text(number,
                style: const TextStyle(
                  color: Color(0xFF70E5F5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                      color: _landingMuted,
                      fontSize: 13,
                      height: 1.6,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerSafety extends StatelessWidget {
  const _CustomerSafety();

  @override
  Widget build(BuildContext context) {
    return _LandingWidth(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;
          const copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(
                eyebrow: 'AN TÂM TRONG TỪNG LƯỢT GỬI',
                title: 'Thông tin rõ ràng khi bạn cần kiểm tra',
                description:
                    'Mỗi lượt gửi gắn với biển số, thời gian và vị trí cụ thể để hỗ trợ tra cứu thuận tiện.',
              ),
              SizedBox(height: 25),
              _CheckItem(
                  title: 'Lịch sử đầy đủ',
                  subtitle: 'Xem lại các lượt gửi đã hoàn thành.'),
              _CheckItem(
                  title: 'Thời gian minh bạch',
                  subtitle: 'Giờ vào và giờ ra được ghi nhận rõ ràng.'),
              _CheckItem(
                  title: 'Kênh phản hồi trực tiếp',
                  subtitle: 'Gửi yêu cầu hỗ trợ ngay trong tài khoản.'),
            ],
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: compact
                ? const Column(
                    children: [copy, SizedBox(height: 45), _ParkingTicket()],
                  )
                : const Row(
                    children: [
                      Expanded(child: copy),
                      SizedBox(width: 75),
                      Expanded(child: _ParkingTicket()),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CheckItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _landingGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF6EE7B7), size: 15),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: _landingMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkingTicket extends StatelessWidget {
  const _ParkingTicket();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Vị trí', 'A-07 · Tầng 1'),
      ('Giờ vào', '08:35 hôm nay'),
      ('Loại xe', 'Ô tô'),
      ('Trạng thái', 'Đang gửi'),
    ];
    return Container(
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141D30), Color(0xFF0A0F1C)],
        ),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: _landingPurple.withValues(alpha: 0.35)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x55000000), blurRadius: 50, offset: Offset(0, 22)),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              ParkingBrandLogo(size: 47),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LƯỢT GỬI ĐANG HOẠT ĐỘNG',
                        style: TextStyle(
                            color: _landingMuted,
                            fontSize: 8,
                            letterSpacing: 1.1)),
                    SizedBox(height: 4),
                    Text('51A-12345',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              _StatusPill(),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22),
            child: Divider(color: _landingBorder, height: 1),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 18) / 2;
              return Wrap(
                spacing: 18,
                runSpacing: 20,
                children: items
                    .map((item) => SizedBox(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.$1,
                                  style: const TextStyle(
                                      color: _landingMuted, fontSize: 9)),
                              const SizedBox(height: 5),
                              Text(item.$2,
                                  style: TextStyle(
                                    color: item.$1 == 'Trạng thái'
                                        ? const Color(0xFF6EE7B7)
                                        : Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 23),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.025),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Thông tin lượt gửi luôn sẵn sàng trong mục “Lượt gửi của tôi”.',
              style: TextStyle(color: _landingMuted, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: _landingGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Đã xác nhận',
          style: TextStyle(
              color: Color(0xFF6EE7B7),
              fontSize: 8,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _CustomerTestimonials extends StatelessWidget {
  const _CustomerTestimonials();

  @override
  Widget build(BuildContext context) {
    const quotes = [
      (
        '“Tôi có thể kiểm tra chỗ trước khi đến nên không còn mất thời gian chạy tìm quanh bãi.”',
        'Minh Anh',
        'Khách gửi xe ô tô'
      ),
      (
        '“Thông tin giờ vào và vị trí xe hiển thị rất rõ, thao tác đặt chỗ cũng đơn giản.”',
        'Quốc Huy',
        'Khách gửi xe thường xuyên'
      ),
      (
        '“Khi cần hỗ trợ tôi có thể gửi phản hồi ngay trong ứng dụng, rất thuận tiện.”',
        'Thu Trang',
        'Khách hàng ParkSmart'
      ),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: const Color(0xFF090D18),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 850 ? 3 : 1;
            final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
            return Column(
              children: [
                const _SectionHeading(
                  eyebrow: 'TRẢI NGHIỆM HƯỚNG ĐẾN KHÁCH HÀNG',
                  title: 'Ít chờ đợi hơn, chủ động nhiều hơn',
                  centered: true,
                ),
                const SizedBox(height: 38),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: quotes
                      .map((quote) => SizedBox(
                            width: width,
                            child: _QuoteCard(
                              quote: quote.$1,
                              name: quote.$2,
                              role: quote.$3,
                            ),
                          ))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String quote;
  final String name;
  final String role;

  const _QuoteCard(
      {required this.quote, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 190),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _landingSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _landingBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 95,
            child: Text(quote,
                style: const TextStyle(
                    color: Color(0xFFD8DEEA), fontSize: 13, height: 1.7)),
          ),
          const Divider(color: _landingBorder),
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(role,
              style: const TextStyle(color: _landingMuted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _CustomerFaq extends StatelessWidget {
  const _CustomerFaq();

  @override
  Widget build(BuildContext context) {
    const faqs = [
      (
        'Tôi có cần đặt chỗ trước không?',
        'Không bắt buộc. Đặt trước giúp bạn chủ động hơn khi bãi có lưu lượng cao.'
      ),
      (
        'Tôi xem vị trí xe ở đâu?',
        'Vị trí tầng và mã slot được hiển thị trong mục “Lượt gửi của tôi”.'
      ),
      (
        'Ứng dụng hỗ trợ những loại xe nào?',
        'Hệ thống hỗ trợ xe máy, ô tô và xe tải theo khu vực được bãi xe cấu hình.'
      ),
      (
        'Nếu thông tin biển số không đúng thì sao?',
        'Bạn có thể gửi phản hồi để nhân viên bãi xe xác minh và hỗ trợ.'
      ),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      decoration: const BoxDecoration(
        color: _landingSurface,
        border: Border.symmetric(horizontal: BorderSide(color: _landingBorder)),
      ),
      child: _LandingWidth(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;
            final heading = const _SectionHeading(
              eyebrow: 'HỎI ĐÁP',
              title: 'Thông tin bạn có thể cần',
              description:
                  'Một vài câu trả lời nhanh trước khi bạn bắt đầu sử dụng ParkSmart.',
            );
            final list = Column(
              children: faqs
                  .map((faq) => _FaqTile(question: faq.$1, answer: faq.$2))
                  .toList(),
            );
            return compact
                ? Column(children: [heading, const SizedBox(height: 35), list])
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

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _landingBorder),
      ),
      child: ExpansionTile(
        iconColor: const Color(0xFF70E5F5),
        collapsedIconColor: _landingMuted,
        title: Text(question,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 17),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(answer,
                style: const TextStyle(
                    color: _landingMuted, fontSize: 12, height: 1.65)),
          ),
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
                gradient: LinearGradient(
                  colors: [
                    _landingPurple.withValues(alpha: 0.18),
                    _landingCyan.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(23),
                border:
                    Border.all(color: _landingPurple.withValues(alpha: 0.42)),
              ),
              child: compact
                  ? Column(
                      children: [
                        const ParkingBrandLogo(size: 65),
                        const SizedBox(height: 20),
                        const _CtaCopy(centered: true),
                        const SizedBox(height: 22),
                        _CtaButton(onPressed: onLogin),
                      ],
                    )
                  : Row(
                      children: [
                        const ParkingBrandLogo(size: 68),
                        const SizedBox(width: 24),
                        const Expanded(child: _CtaCopy()),
                        const SizedBox(width: 24),
                        _CtaButton(onPressed: onLogin),
                      ],
                    ),
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
              letterSpacing: 1.5,
            )),
        const SizedBox(height: 6),
        Text('Chủ động chỗ đậu cho hành trình tiếp theo.',
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(height: 6),
        Text('Đăng ký tài khoản và trải nghiệm quy trình gửi xe đơn giản hơn.',
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
        border: Border(top: BorderSide(color: _landingBorder)),
      ),
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
                style: TextStyle(color: _landingMuted, fontSize: 10),
              );
              const copyright = Text('© 2026 ParkSmart SWP08',
                  style: TextStyle(color: Color(0xFF697386), fontSize: 10));
              return compact
                  ? const Column(
                      children: [
                        brand,
                        SizedBox(height: 12),
                        copy,
                        SizedBox(height: 8),
                        copyright,
                      ],
                    )
                  : const Row(
                      children: [
                        brand,
                        Spacer(),
                        copy,
                        SizedBox(width: 28),
                        copyright,
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

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

class _SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? description;
  final bool centered;

  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    this.description,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(eyebrow,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              color: Color(0xFFB6A0FF),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            )),
        const SizedBox(height: 12),
        Text(title,
            textAlign: centered ? TextAlign.center : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 39,
              height: 1.13,
              letterSpacing: -1.2,
              fontWeight: FontWeight.w800,
            )),
        if (description != null) ...[
          const SizedBox(height: 12),
          Text(description!,
              textAlign: centered ? TextAlign.center : TextAlign.left,
              style: const TextStyle(
                color: _landingMuted,
                fontSize: 14,
                height: 1.7,
              )),
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
                letterSpacing: 1.4,
              )),
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
        Text(label, style: const TextStyle(color: _landingMuted, fontSize: 10)),
      ],
    );
  }
}
