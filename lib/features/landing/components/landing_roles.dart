import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';

class LandingRoles extends StatelessWidget {
  const LandingRoles({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 64),
                _buildGrid(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('4 VAI TRÒ NGƯỜI DÙNG', 
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFF67E8F9))),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white),
              children: [
                TextSpan(text: 'Mỗi người một giao diện, '),
                TextSpan(text: 'cùng một dữ liệu', style: TextStyle(color: Color(0xFFA78BFA))),
              ]
            ),
          ),
          const SizedBox(height: 16),
          const Text('Hệ thống phân quyền rõ ràng, mỗi vai trò chỉ thấy và thao tác những gì cần thiết.', 
            style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildGrid(bool isMobile) {
    final cards = [
      _roleCard('01', 'Parking Manager', 'Quản lý tổng thể bãi xe: tổng quan, sơ đồ slot, chính sách giá, báo cáo doanh thu.', 
        ['Dashboard tổng quan', 'Quản lý slot theo tầng', 'Cấu hình giá vé', 'Báo cáo 7 ngày'], 'manager', Icons.dashboard_rounded, const Color(0xFF7C3AED)),
      _roleCard('02', 'Staff — Nhân viên', 'Trực tiếp tại bãi xe: quét biển số, ghi nhận xe vào/ra và xử lý tình huống bất thường.', 
        ['Check-in xe', 'Check-out & tính phí', 'Xử lý sự cố / ngoại lệ', 'Tìm xe theo biển số'], 'staff1', Icons.person_rounded, const Color(0xFF06B6D4)),
      _roleCard('03', 'Driver — Người gửi', 'Chủ xe tự quản lý: xem xe đang gửi, lịch sử phiên gửi, đặt chỗ trước và gửi phản hồi.', 
        ['Xem xe đang gửi', 'Lịch sử + QR phiên', 'Đặt chỗ trước', 'Gửi phản hồi'], 'driver1', Icons.directions_car_rounded, const Color(0xFF10B981)),
      _roleCard('04', 'Admin — Quản trị', 'Toàn quyền hệ thống: quản lý tài khoản người dùng theo role, cấu hình thông tin.', 
        ['Thêm / sửa / xóa tài khoản', 'Phân quyền theo role', 'Cấu hình hệ thống', 'Quản lý thông tin'], 'admin', Icons.admin_panel_settings_rounded, const Color(0xFFF97316)),
    ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.2, end: 0);

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 18), child: c)).toList(),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 18),
          Expanded(child: cards[1]),
          const SizedBox(width: 18),
          Expanded(child: cards[2]),
          const SizedBox(width: 18),
          Expanded(child: cards[3]),
        ],
      ),
    );
  }

  Widget _roleCard(String numStr, String title, String desc, List<String> perms, String user, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.3))),
                child: Icon(icon, color: color),
              ),
              Text(numStr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, color: Color(0xFF4E5D72))),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 10),
          Text(desc, style: const TextStyle(fontSize: 13, height: 1.75, color: Color(0xFF8492A6))),
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: perms.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFFA78BFA), shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(p, style: const TextStyle(fontSize: 12.5, color: Color(0xFF8492A6)))),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withValues(alpha: 0.07))),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('User', style: TextStyle(fontSize: 10.5, color: Color(0xFF8492A6))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)), child: Text(user, style: const TextStyle(fontSize: 10.5, color: Color(0xFF67E8F9)))),
                ]),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Pass', style: TextStyle(fontSize: 10.5, color: Color(0xFF8492A6))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)), child: const Text('bất kỳ', style: TextStyle(fontSize: 10.5, color: Color(0xFF67E8F9)))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
