import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';

class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key});

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
          _buildGrid(isMobile),
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
          const Text('TÍNH NĂNG CHÍNH', 
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFFA78BFA))),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white),
              children: [
                TextSpan(text: 'Mọi công việc trong '),
                TextSpan(text: 'một hệ thống', style: TextStyle(color: Color(0xFF67E8F9))),
              ]
            ),
          ),
          const SizedBox(height: 16),
          const Text('Từ cổng vào đến báo cáo cuối ngày, mọi thao tác đều được tổ chức rõ ràng và phản hồi tức thì.', 
            style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildGrid(bool isMobile) {
    final cards = [
      _featureCard('Quản lý slot real-time', 'Theo dõi trạng thái từng ô đỗ — trống, có xe, đặt trước, bảo trì — trên sơ đồ trực quan theo từng tầng.', '190 ô đỗ / 4 tầng', Icons.grid_view_rounded, const Color(0xFF7C3AED)),
      _featureCard('Check-in / Check-out nhanh', 'Nhập biển số, chọn loại xe, hệ thống tự tìm slot phù hợp. Kết thúc phiên: tính phí và in vé tức thì.', 'Xe máy · Ô tô · Xe tải', Icons.login_rounded, const Color(0xFF06B6D4)),
      _featureCard('Đặt chỗ trước (Prebooking)', 'Người gửi xe chủ động chọn thời gian, loại xe và tầng trước khi đến. Nhận mã xác nhận và QR code ngay.', 'Mã QR · Xác nhận tức thì', Icons.event_available_rounded, const Color(0xFF10B981)),
      _featureCard('Xử lý sự cố ngoại lệ', 'Tập hợp các trường hợp mất vé, sai biển số, quá giờ, chưa thanh toán — nhân viên giải quyết ngay tại chỗ.', 'Mất vé · Quá giờ · Sai biển', Icons.warning_amber_rounded, const Color(0xFFF97316)),
      _featureCard('Báo cáo & thống kê', 'Biểu đồ doanh thu 7 ngày, lưu lượng xe theo giờ, công suất bãi — tất cả hiển thị trực quan cho manager.', 'Doanh thu · Lưu lượng', Icons.bar_chart_rounded, const Color(0xFFEC4899)),
      _featureCard('Quản lý tài khoản', 'Admin toàn quyền thêm/sửa/xóa tài khoản, phân quyền theo role và cấu hình thông tin hệ thống bãi xe.', 'Admin · Phân quyền', Icons.manage_accounts_rounded, const Color(0xFF3B82F6)),
    ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.2, end: 0);

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 20), child: c)).toList(),
      );
    }

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 20),
              Expanded(child: cards[1]),
              const SizedBox(width: 20),
              Expanded(child: cards[2]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[3]),
              const SizedBox(width: 20),
              Expanded(child: cards[4]),
              const SizedBox(width: 20),
              Expanded(child: cards[5]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _featureCard(String title, String desc, String tag, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(fontSize: 13.5, height: 1.75, color: Color(0xFF8492A6)), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF4E5D72))),
          ),
        ],
      ),
    );
  }
}
