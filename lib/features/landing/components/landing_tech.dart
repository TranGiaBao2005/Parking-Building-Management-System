import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';

class LandingTech extends StatelessWidget {
  const LandingTech({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 64),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildStackList()),
              if (isMobile) const SizedBox(height: 48) else const SizedBox(width: 48),
              Expanded(flex: 1, child: _buildArchDiagram(isMobile)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CÔNG NGHỆ', 
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFFA78BFA))),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white),
              children: [
                TextSpan(text: 'Xây dựng bằng '),
                TextSpan(text: 'Flutter & Dart', style: TextStyle(color: Color(0xFF67E8F9))),
              ]
            ),
          ),
          const SizedBox(height: 16),
          const Text('Stack hiện đại, cross-platform — chạy được trên Web, Desktop và Mobile từ cùng một codebase.', 
            style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildStackList() {
    return Column(
      children: [
        _stackItem(const Color(0xFF54C5F8), 'Flutter 3', 'Framework UI đa nền tảng của Google — Web, Desktop, Mobile'),
        _stackItem(const Color(0xFFA78BFA), 'go_router ^14.0', 'URL-based navigation, web-friendly routing, deep-link support'),
        _stackItem(const Color(0xFF67E8F9), 'provider ^6.1', 'State management — ChangeNotifier pattern toàn cục'),
        _stackItem(const Color(0xFF6EE7B7), 'fl_chart ^0.69', 'Biểu đồ doanh thu, lưu lượng xe (line chart & bar chart)'),
        _stackItem(const Color(0xFFFDBA74), 'qr_flutter ^4.1', 'Sinh mã QR cho phiên gửi xe và đặt chỗ trước'),
        _stackItem(const Color(0xFFF9A8D4), 'flutter_animate ^4.5', 'Micro-animations: fade-in, slide, bounce, scale effects'),
      ].animate(interval: 100.ms).fadeIn().slideX(begin: -0.1, end: 0),
    );
  }

  Widget _stackItem(Color color, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 9, height: 9, margin: const EdgeInsets.only(top: 7), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12.5, height: 1.6, color: Color(0xFF8492A6))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildArchDiagram(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('KIẾN TRÚC 3 TẦNG', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: Color(0xFF8492A6))),
          const SizedBox(height: 24),
          _archLayer('Features (UI Layer)', 'Screens, Widgets, Shells', const Color(0xFF7C3AED), Icons.important_devices_rounded),
          _archArrow(),
          _archLayer('MockDataService (Provider)', 'Business logic · State · Notifier', const Color(0xFF06B6D4), Icons.compare_arrows_rounded),
          _archArrow(),
          _archLayer('Models (Dart)', 'User · Slot · Session · ParkingSession', const Color(0xFF10B981), Icons.data_object_rounded),
          const SizedBox(height: 24),
          const Text('MockDataService đóng vai trò "backend giả" — dễ thay bằng REST API thật khi cần.', style: TextStyle(fontSize: 11.5, color: Color(0xFF8492A6), height: 1.65)),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _archArrow() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Icon(Icons.keyboard_double_arrow_down_rounded, color: const Color(0xFF4E5D72), size: 24),
      ),
    );
  }

  Widget _archLayer(String title, String desc, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
                Text(desc, style: const TextStyle(fontSize: 11.5, color: Color(0xFF8492A6))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
