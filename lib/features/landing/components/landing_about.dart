import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';
import 'dart:ui';
import '../../../shared/widgets/parking_brand_logo.dart';

class LandingAboutCtaFooter extends StatelessWidget {
  const LandingAboutCtaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Column(
      children: [
        _buildAboutSection(isMobile),
        const SizedBox(height: 40),
        _buildFooter(),
      ],
    );
  }

  Widget _buildAboutSection(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F1C),
        border: Border.symmetric(horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('VỀ DỰ ÁN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFF67E8F9))),
                      const SizedBox(height: 16),
                      RichText(text: const TextSpan(style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white), children: [TextSpan(text: 'Đồ án '), TextSpan(text: 'SU26SWP08', style: TextStyle(color: Color(0xFFA78BFA)))] )),
                      const SizedBox(height: 16),
                      const Text('Được phát triển như một đồ án môn học Software Practice — SU26 với stack Flutter/Dart, kiến trúc phân tầng rõ ràng và giao diện dark mode hiện đại.', style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
                      const SizedBox(height: 32),
                      _aboutMeta(Icons.folder_rounded, 'SU26SWP08 — Parking Building Management System'),
                      _aboutMeta(Icons.code_rounded, 'Flutter 3 · Dart · Provider · GoRouter · fl_chart'),
                      _aboutMeta(Icons.devices_rounded, 'Web · Desktop · từ một codebase Dart duy nhất'),
                    ],
                  ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                ),
                if (isMobile) const SizedBox(height: 48) else const SizedBox(width: 64),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0xFF10B981), blurRadius: 10)])).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 1.seconds),
                            const SizedBox(width: 14),
                            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Prototype hoàn chỉnh', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF6EE7B7))),
                              SizedBox(height: 4),
                              Text('MockData sẵn sàng demo, thiết kế sẵn sàng tích hợp API thật.', style: TextStyle(fontSize: 13, color: Color(0xFF8492A6), height: 1.6)),
                            ])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _ssItem('7+', 'Màn hình')),
                          const SizedBox(width: 12),
                          Expanded(child: _ssItem('190', 'Slot xe')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _ssItem('4', 'Role người dùng')),
                          const SizedBox(width: 12),
                          Expanded(child: _ssItem('100%', 'Flutter Widget')),
                        ],
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _aboutMeta(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF67E8F9), size: 16),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13.5, color: Color(0xFF8492A6), height: 1.6))),
        ],
      ),
    );
  }

  Widget _ssItem(String val, String lbl) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.07))),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 4),
          Text(lbl, style: const TextStyle(fontSize: 11, color: Color(0xFF8492A6))),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.07)))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const ParkingBrandLogo(size: 24),
              const SizedBox(width: 10),
              Text('ParkSmart SWP08', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
          Text('© 2026 SU26SWP08 — Parking Building Management System', style: TextStyle(fontSize: 12, color: Color(0xFF4E5D72))),
          Text('Built with Flutter & Dart', style: TextStyle(fontSize: 11, color: Color(0xFF4E5D72))),
        ],
      ),
    );
  }
}
