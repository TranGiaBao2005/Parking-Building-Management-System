import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';

class LandingDemo extends StatelessWidget {
  const LandingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF08121E),
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
                const SizedBox(height: 48),
                _buildDemoTable(isMobile),
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
          const Text('THỬ NGAY', 
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFF67E8F9))),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white),
              children: [
                TextSpan(text: 'Tài khoản demo '),
                TextSpan(text: 'sẵn sàng', style: TextStyle(color: Color(0xFFA78BFA))),
              ]
            ),
          ),
          const SizedBox(height: 16),
          const Text('Đăng nhập bằng bất kỳ tài khoản nào bên dưới. Mật khẩu có thể nhập bất kỳ ký tự nào.', 
            style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildDemoTable(bool isMobile) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: isMobile ? _buildMobileCards() : _buildDesktopTable(),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF06B6D4).withValues(alpha: 0.2))),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFF67E8F9), size: 16),
              SizedBox(width: 10),
              Expanded(child: Text('Dữ liệu demo được tạo ngẫu nhiên mỗi khi khởi động app. Đây là prototype không kết nối backend thật — dữ liệu sẽ mất sau khi reload.', style: TextStyle(fontSize: 12.5, color: Color(0xFF8492A6), height: 1.6))),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(const Color(0xFF7C3AED).withValues(alpha: 0.08)),
      dataRowMaxHeight: 70,
      dataRowMinHeight: 70,
      columns: const [
        DataColumn(label: Text('Vai trò', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFA78BFA)))),
        DataColumn(label: Text('Username', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFA78BFA)))),
        DataColumn(label: Text('Password', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFA78BFA)))),
        DataColumn(label: Text('Truy cập', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFA78BFA)))),
        DataColumn(label: Text('Tính năng chính', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFA78BFA)))),
      ],
      rows: [
        _tableRow('Manager', const Color(0xFF7C3AED), const Color(0xFFA78BFA), 'manager', 'Dashboard, slot, giá vé, báo cáo'),
        _tableRow('Staff', const Color(0xFF06B6D4), const Color(0xFF67E8F9), 'staff1 / staff2', 'Check-in, check-out, xử lý sự cố'),
        _tableRow('Driver', const Color(0xFF10B981), const Color(0xFF6EE7B7), 'driver1 / driver2', 'Đặt chỗ, lịch sử, phản hồi'),
        _tableRow('Admin', const Color(0xFFF97316), const Color(0xFFFDBA74), 'admin', 'Quản lý tài khoản, cấu hình hệ thống'),
      ],
    );
  }

  DataRow _tableRow(String role, Color color, Color textCol, String user, String features) {
    return DataRow(
      cells: [
        DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(99), border: Border.all(color: color.withValues(alpha: 0.3))), child: Text(role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textCol)))),
        DataCell(_codeBlock(user)),
        DataCell(_codeBlock('bất kỳ')),
        DataCell(_codeBlock('/${role.toLowerCase()}')),
        DataCell(Text(features, style: const TextStyle(fontSize: 13, color: Color(0xFF8492A6)))),
      ],
    );
  }

  Widget _buildMobileCards() {
    return Column(
      children: [
        _mobileCard('Manager', const Color(0xFF7C3AED), const Color(0xFFA78BFA), 'manager', 'Dashboard, slot, báo cáo'),
        _mobileCard('Staff', const Color(0xFF06B6D4), const Color(0xFF67E8F9), 'staff1', 'Check-in, check-out'),
        _mobileCard('Driver', const Color(0xFF10B981), const Color(0xFF6EE7B7), 'driver1', 'Đặt chỗ, lịch sử'),
        _mobileCard('Admin', const Color(0xFFF97316), const Color(0xFFFDBA74), 'admin', 'Cấu hình hệ thống'),
      ],
    );
  }

  Widget _mobileCard(String role, Color color, Color textCol, String user, String features) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(99), border: Border.all(color: color.withValues(alpha: 0.3))), child: Text(role, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textCol))),
              _codeBlock(user),
            ],
          ),
          const SizedBox(height: 12),
          Text(features, style: const TextStyle(fontSize: 13, color: Color(0xFF8492A6))),
        ],
      ),
    );
  }

  Widget _codeBlock(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFF06B6D4).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(5)),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF67E8F9))),
    );
  }
}
