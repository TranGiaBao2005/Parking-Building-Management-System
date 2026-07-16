import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/mock_data_service.dart';

// ──────────────────────────────────────────────
// Model
// ──────────────────────────────────────────────
enum _Sender { user, bot }

class _Message {
  final String text;
  final _Sender sender;
  final DateTime time;
  _Message({required this.text, required this.sender}) : time = DateTime.now();
}

// ──────────────────────────────────────────────
// Mock bot "brain" — keyword matching
// ──────────────────────────────────────────────
class _BotBrain {
  static final _rng = Random();

  static final _rules = <String, List<String>>{
    'giá|giá cả|phí|bao nhiêu|tiền': [
      'Bãi xe áp dụng mức giá:\n• 🏍 Xe máy: 5.000đ/giờ\n• 🚗 Ô tô: 15.000đ/giờ\n• 🚛 Xe tải: 25.000đ/giờ\nGửi qua đêm được giảm 20%. Hàng tháng liên hệ quản lý để nhận ưu đãi.',
      'Chi tiết bảng giá hiển thị ngay ở tab "Bãi xe" nhé! Giá theo giờ từ 5k–25k tùy loại xe.',
    ],
    'chỗ|slot|trống|còn|hết|tầng|floor': [
      'Tình trạng chỗ trống cập nhật theo thời gian thực tại tab "Bãi xe". Tầng 1–2 dành cho xe máy, tầng 3–4 dành cho ô tô.',
      'Bạn có thể xem ngay tại màn hình chính! Mỗi tầng có thanh hiển thị % chỗ còn trống với màu xanh/vàng/đỏ.',
    ],
    'đặt|booking|prebooking|giữ chỗ|reserve': [
      'Để đặt chỗ trước:\n1. Bấm tab **"Đặt chỗ"** ở menu bên dưới\n2. Nhập biển số xe\n3. Chọn loại xe, tầng và khung giờ\n4. Xác nhận — hệ thống tạo mã QR cho bạn 🎉',
      'Chức năng đặt chỗ trước (pre-booking) cho phép bạn giữ slot lên đến 2 giờ trước khi vào. Vào tab "Đặt chỗ" nhé!',
    ],
    'qr|mã qr|quét|check in|check-in|vào bãi': [
      'Khi đến bãi, nhân viên sẽ quét mã QR trên app của bạn để check-in tự động. Mã QR hiển thị trong phần "Lượt gửi".',
      'Mã QR được tạo sau khi đặt chỗ. Bạn vào tab "Lượt gửi" → chọn lượt → bấm hiện QR là xong!',
    ],
    'địa chỉ|ở đâu|vị trí|đường|location|map|bản đồ': [
      'Bãi xe tọa lạc tại **123 Nguyễn Văn Linh, Q.7, TP.HCM**.\n📍 Cách trung tâm Q.1 khoảng 8 km. Bấm "Tìm kiếm" để mở Google Maps chỉ đường!',
      'Địa chỉ: 123 Nguyễn Văn Linh, Q.7. Bạn bấm nút "Tìm kiếm" ở trang chủ để xem bản đồ và chỉ đường nhé.',
    ],
    'giờ|mở cửa|đóng cửa|hoạt động|thời gian': [
      'Bãi xe mở cửa từ **06:00 – 22:00** hàng ngày kể cả cuối tuần và ngày lễ.',
      'Giờ hoạt động: 6 giờ sáng đến 10 giờ đêm. Nếu bạn cần gửi qua đêm, vui lòng liên hệ trực tiếp với bảo vệ.',
    ],
    'phản hồi|feedback|góp ý|khiếu nại|complaint': [
      'Bạn có thể gửi phản hồi tại tab "Phản hồi" trong menu. Chúng tôi đọc mọi ý kiến và phản hồi trong vòng 24h!',
      'Mọi góp ý xin gửi qua tab "Phản hồi". Team hỗ trợ sẽ xử lý và liên hệ lại với bạn sớm nhất có thể 🙏',
    ],
    'xin chào|hello|hi|chào|hey': [
      'Xin chào! 👋 Tôi là trợ lý ảo của bãi xe SWP08. Bạn có thể hỏi tôi về:\n• Giá gửi xe\n• Tình trạng chỗ trống\n• Cách đặt chỗ trước\n• Địa chỉ & giờ mở cửa',
      'Chào bạn! 😊 Tôi có thể giúp bạn tìm hiểu về bãi xe — giá cả, đặt chỗ, địa chỉ hay bất kỳ thắc mắc nào khác!',
    ],
    'cảm ơn|thanks|thank you|tks': [
      'Không có gì! 😊 Nếu cần thêm hỗ trợ, bạn cứ hỏi nhé!',
      'Rất vui được giúp đỡ! Chúc bạn gửi xe vui vẻ 🚗✨',
    ],
  };

  static final _fallbacks = [
    'Xin lỗi, tôi chưa hiểu câu hỏi đó. Bạn có thể hỏi về:\n• Giá gửi xe 💰\n• Chỗ trống theo tầng 🅿️\n• Cách đặt chỗ trước 📌\n• Địa chỉ & giờ mở cửa 📍',
    'Câu hỏi hay đấy! Nhưng hiện tại tôi chỉ hỗ trợ các thông tin về bãi xe như giá, địa chỉ, cách đặt chỗ... Bạn thử hỏi lại theo chủ đề đó nhé!',
    'Tôi chưa có câu trả lời cho điều này. Thử hỏi về "giá xe", "chỗ trống", "đặt chỗ" hoặc "địa chỉ bãi xe" xem sao! 😊',
  ];

  static String respond(String input) {
    final lower = input.toLowerCase().trim();
    for (final entry in _rules.entries) {
      final keywords = entry.key.split('|');
      if (keywords.any((kw) => lower.contains(kw))) {
        final responses = entry.value;
        return responses[_rng.nextInt(responses.length)];
      }
    }
    return _fallbacks[_rng.nextInt(_fallbacks.length)];
  }
}

// ──────────────────────────────────────────────
// Chatbot Screen
// ──────────────────────────────────────────────
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_Message> _messages = [];
  bool _typing = false;

  @override
  void initState() {
    super.initState();
    // Greeting message
    _messages.add(_Message(
      text:
          'Xin chào! 👋 Tôi là trợ lý ảo của bãi xe **SWP08**.\nBạn có thể hỏi tôi về giá cả, chỗ trống, cách đặt chỗ, địa chỉ...',
      sender: _Sender.bot,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _typing) return;

    final svc = context.read<MockDataService>();

    setState(() {
      _messages.add(_Message(text: text, sender: _Sender.user));
      _controller.clear();
      _typing = true;
    });
    _scrollToBottom();

    // Simulate typing delay
    final delay = 800 + Random().nextInt(800);
    Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      final reply = _buildReply(text, svc);
      setState(() {
        _messages.add(_Message(text: reply, sender: _Sender.bot));
        _typing = false;
      });
      _scrollToBottom();
    });
  }

  String _buildReply(String input, MockDataService svc) {
    return _BotBrain.respond(input);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Header
          _ChatHeader(),

          // Gợi ý nhanh
          _QuickSuggestions(onTap: (q) {
            _controller.text = q;
            _sendMessage();
          }),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (_typing && i == _messages.length) {
                  return _TypingBubble();
                }
                final msg = _messages[i];
                return _ChatBubble(message: msg, index: i);
              },
            ),
          ),

          // Input bar
          _InputBar(
            controller: _controller,
            typing: _typing,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Header
// ──────────────────────────────────────────────
class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trợ lý ParkSmart',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: AppColors.available,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Đang hoạt động',
                    style: TextStyle(
                        color: AppColors.available,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

// ──────────────────────────────────────────────
// Quick suggestions
// ──────────────────────────────────────────────
class _QuickSuggestions extends StatelessWidget {
  final void Function(String) onTap;
  const _QuickSuggestions({required this.onTap});

  static const _chips = [
    'Giá gửi xe?',
    'Còn chỗ trống không?',
    'Cách đặt chỗ?',
    'Địa chỉ bãi xe?',
    'Giờ mở cửa?',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: AppColors.bg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _chips
              .map((c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onTap(c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.accent.withOpacity(0.4)),
                        ),
                        child: Text(c,
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Chat bubble
// ──────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final _Message message;
  final int index;
  const _ChatBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == _Sender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: AppColors.border),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppColors.textSecondary, size: 16),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(
        delay: Duration(milliseconds: min(index * 40, 200)),
        duration: 200.ms);
  }
}

// ──────────────────────────────────────────────
// Typing indicator bubble
// ──────────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      )..repeat(
          reverse: true,
          period: Duration(milliseconds: 800 + i * 150),
        ),
    );
  }

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ctrls[i],
                  builder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 7,
                    height: 7 + _ctrls[i].value * 5,
                    decoration: BoxDecoration(
                      color: AppColors.accent
                          .withOpacity(0.4 + _ctrls[i].value * 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

// ──────────────────────────────────────────────
// Input bar
// ──────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool typing;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.typing,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Hỏi gì đó về bãi xe...',
                hintStyle: const TextStyle(
                    color: AppColors.textMuted, fontSize: 14),
                filled: true,
                fillColor: AppColors.bg,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                      color: AppColors.accent, width: 1.5),
                ),
              ),
              onSubmitted: (_) => onSend(),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: typing ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: typing
                    ? AppColors.surfaceLight
                    : AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                typing
                    ? Icons.hourglass_empty_rounded
                    : Icons.send_rounded,
                color: typing
                    ? AppColors.textMuted
                    : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
