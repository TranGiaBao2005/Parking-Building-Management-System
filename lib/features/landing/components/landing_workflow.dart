import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/utils/responsive.dart';

class LandingWorkflow extends StatelessWidget {
  const LandingWorkflow({super.key});

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
          _buildSteps(isMobile),
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
          const Text('QUY TRÌNH ĐƠN GIẢN', 
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 1.8, color: Color(0xFFA78BFA))),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -1, color: Colors.white),
              children: [
                TextSpan(text: 'Từ lúc xe đến cho đến '),
                TextSpan(text: 'khi rời bãi', style: TextStyle(color: Color(0xFF67E8F9))),
              ]
            ),
          ),
          const SizedBox(height: 16),
          const Text('Mỗi bước trong luồng gửi xe được thiết kế tối giản, nhanh và chính xác.', 
            style: TextStyle(fontSize: 16, height: 1.8, color: Color(0xFF8492A6))),
        ],
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildSteps(bool isMobile) {
    final cards = [
      _stepCard('1', 'Nhận diện xe', 'Nhân viên nhập biển số, chọn loại xe (máy/ô tô). Hệ thống xác nhận thông tin.', ['Xe máy', 'Ô tô', 'Xe tải']),
      _stepCard('2', 'Phân bổ slot', 'Hệ thống tự tìm ô đỗ phù hợp theo loại xe và tầng, đánh dấu slot đang dùng ngay lập tức.', ['T1-T2: xe máy', 'T3-T4: ô tô']),
      _stepCard('3', 'Theo dõi phiên gửi', 'Thời gian check-in, trạng thái slot và thông tin xe được cập nhật liên tục.', ['QR code', 'Real-time']),
      _stepCard('4', 'Check-out & Thanh toán', 'Tính phí tự động theo thời gian. Slot trở về trạng thái trống, thống kê cập nhật.', ['Theo giờ', 'Qua đêm', 'Theo tháng']),
    ].animate(interval: 100.ms).fadeIn().slideY(begin: 0.2, end: 0);

    return Stack(
      children: [
        if (!isMobile)
          Positioned(
            top: 24, left: 24, right: 24,
            child: Container(height: 1, color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
          ),
        if (isMobile)
          Column(
            children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 20), child: c)).toList(),
          )
        else
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 20),
                Expanded(child: cards[1]),
                const SizedBox(width: 20),
                Expanded(child: cards[2]),
                const SizedBox(width: 20),
                Expanded(child: cards[3]),
              ],
            ),
          ),
      ],
    );
  }

  Widget _stepCard(String numStr, String title, String desc, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: const Color(0xFF7C3AED).withValues(alpha: 0.15), border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.4)), shape: BoxShape.circle),
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(numStr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFA78BFA))),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.035), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.07))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 10),
                Text(desc, style: const TextStyle(fontSize: 13, height: 1.75, color: Color(0xFF8492A6))),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(99), border: Border.all(color: Colors.white.withValues(alpha: 0.07))),
                    child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF4E5D72))),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
