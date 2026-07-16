import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'landing_screen.dart';

// ──────────────────────────────────────────────
// Theme constants (light – matching app)
// ──────────────────────────────────────────────
const _bg = Color(0xFFF8FAFC);
const _surface = Color(0xFFFFFFFF);
const _surfaceLight = Color(0xFFF1F5F9);
const _border = Color(0xFFE2E8F0);
const _muted = Color(0xFF64748B);
const _text = Color(0xFF0F172A);
const _accent = Color(0xFF10B981);
const _accentBg = Color(0xFFECFDF5);

// ──────────────────────────────────────────────
// Bot "brain" – keyword matching
// ──────────────────────────────────────────────
class _BotBrain {
  static final _rng = Random();

  static final _rules = <String, List<String>>{
    'giá|phí|bao nhiêu|tiền': [
      'Bãi xe áp dụng mức giá:\n• 🏍 Xe máy: 5.000đ/giờ\n• 🚗 Ô tô: 15.000đ/giờ\n• 🚛 Xe tải: 25.000đ/giờ\nGửi qua đêm được giảm 20%.',
      'Chi tiết bảng giá hiển thị tại tab "Bãi xe" nhé! Giá theo giờ từ 5k–25k tùy loại xe.',
    ],
    'chỗ|slot|trống|còn|hết|tầng': [
      'Tình trạng chỗ trống:\n• Tầng 1-2 (Xe máy): 38/45 chỗ ✅\n• Tầng 3-4 (Ô tô): 26/60 chỗ 🟡\nCòn tổng 86 chỗ trống hiện tại!',
      'Bạn có thể xem ngay! Tầng 1–2 dành cho xe máy, tầng 3–4 cho ô tô.',
    ],
    'đặt|booking|giữ chỗ|reserve': [
      'Để đặt chỗ trước:\n1. Đăng ký tài khoản\n2. Chọn loại xe & khung giờ\n3. Xác nhận – nhận mã QR\n4. Đến bãi, quét QR là xong! 🎉',
    ],
    'qr|mã|quét|check in|vào bãi': [
      'Mã QR được tạo sau khi đặt chỗ thành công. Nhân viên quét mã và bạn vào bãi ngay!',
    ],
    'địa chỉ|ở đâu|vị trí|đường|bản đồ': [
      'Bãi xe tọa lạc tại:\n📍 123 Nguyễn Văn Linh, Q.7, TP.HCM\nBấm "Tìm kiếm" để xem bản đồ và chỉ đường!',
    ],
    'giờ|mở cửa|đóng cửa|thời gian': [
      'Bãi xe mở cửa từ 06:00 – 22:00 hàng ngày kể cả cuối tuần và ngày lễ.',
    ],
    'xin chào|hello|hi|chào|hey': [
      'Xin chào! 👋 Tôi là trợ lý ảo của ParkSmart SWP08.\nBạn có thể hỏi tôi về:\n• Giá gửi xe 💰\n• Chỗ trống theo tầng 🅿️\n• Cách đặt chỗ 📌\n• Địa chỉ & giờ mở cửa 📍',
    ],
    'cảm ơn|thanks|thank you': [
      'Không có gì! 😊 Chúc bạn gửi xe vui vẻ!',
      'Rất vui được giúp đỡ! 🚗✨',
    ],
  };

  static final _fallbacks = [
    'Xin lỗi, tôi chưa hiểu câu hỏi đó. Bạn có thể hỏi về:\n• Giá gửi xe 💰\n• Chỗ trống 🅿️\n• Cách đặt chỗ 📌\n• Địa chỉ & giờ mở cửa 📍',
    'Tôi chưa có câu trả lời cho điều này. Thử hỏi "giá xe", "chỗ trống" hoặc "đặt chỗ" nhé! 😊',
  ];

  static String respond(String input) {
    final lower = input.toLowerCase().trim();
    for (final entry in _rules.entries) {
      if (entry.key.split('|').any((kw) => lower.contains(kw))) {
        final list = entry.value;
        return list[_rng.nextInt(list.length)];
      }
    }
    return _fallbacks[_rng.nextInt(_fallbacks.length)];
  }
}

enum _Sender { user, bot }

class _Message {
  final String text;
  final _Sender sender;
  final DateTime time;
  _Message({required this.text, required this.sender}) : time = DateTime.now();
}

// ──────────────────────────────────────────────
// Landing Chat Screen
// ──────────────────────────────────────────────
class LandingChatScreen extends StatefulWidget {
  const LandingChatScreen({super.key});

  @override
  State<LandingChatScreen> createState() => _LandingChatScreenState();
}

class _LandingChatScreenState extends State<LandingChatScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_Message> _messages = [];
  bool _typing = false;



  @override
  void initState() {
    super.initState();
    _messages.add(_Message(
      text: 'Xin chào! 👋 Tôi là trợ lý ảo của bãi xe SWP08.\nBạn có thể hỏi tôi về giá cả, chỗ trống, cách đặt chỗ, địa chỉ...',
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

    setState(() {
      _messages.add(_Message(text: text, sender: _Sender.user));
      _controller.clear();
      _typing = true;
    });
    _scrollToBottom();

    final delay = 700 + Random().nextInt(700);
    Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() {
        _messages.add(_Message(text: _BotBrain.respond(text), sender: _Sender.bot));
        _typing = false;
      });
      _scrollToBottom();
    });
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
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          LandingNavbar(
            activePage: 'chat',
            onLogin: () => context.go('/login'),
          ),
          Expanded(
            child: isMobile ? _buildMobile() : _buildDesktop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        // ── Left sidebar (giống app thật)
        Container(
          width: 260,
          decoration: const BoxDecoration(
            color: _surface,
            border: Border(right: BorderSide(color: _border)),
          ),
          child: _buildSidebar(),
        ),
        // ── Right: chat area
        Expanded(child: _buildChatArea()),
      ],
    );
  }

  Widget _buildMobile() {
    return _buildChatArea();
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: _border)),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Parkwave AI',
                  style: TextStyle(color: _text, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            style: const TextStyle(color: _text, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Tìm hội thoại',
              hintStyle: const TextStyle(color: _muted, fontSize: 12),
              prefixIcon: const Icon(Icons.search_rounded, color: _muted, size: 16),
              filled: true,
              fillColor: _surfaceLight,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // New chat button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Hội thoại mới', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Conversations label
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Hội thoại',
              style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 8),

        // Conversation list
        Expanded(
          child: _messages.length <= 1
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Chưa có hội thoại nào',
                      style: TextStyle(color: _muted, fontSize: 12)),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: _accentBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _accent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline_rounded, color: _accent, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _messages.firstWhere(
                                (m) => m.sender == _Sender.user,
                                orElse: () => _messages.first,
                              ).text.split('\n').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),

        // Login CTA at bottom of sidebar
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_accent.withValues(alpha: 0.08), const Color(0xFF06B6D4).withValues(alpha: 0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accent.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Lưu hội thoại',
                  style: TextStyle(color: _text, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Đăng nhập để lưu lịch sử trò chuyện',
                  style: TextStyle(color: _muted, fontSize: 11)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _accent,
                    side: const BorderSide(color: _accent),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Đăng nhập', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        // Header
        _buildChatHeader(),

        // Quick suggestions
        _buildQuickSuggestions(),

        // Messages
        Expanded(
          child: _messages.isEmpty
              ? _buildWelcomeScreen()
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: _messages.length + (_typing ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (_typing && i == _messages.length) {
                      return _buildTypingBubble();
                    }
                    return _buildBubble(_messages[i], i);
                  },
                ),
        ),

        // Input bar
        _buildInputBar(),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trợ lý ParkSmart',
                  style: TextStyle(color: _text, fontSize: 15, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: _accent),
                  SizedBox(width: 5),
                  Text('Đang hoạt động',
                      style: TextStyle(color: _accent, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _chips = [
    'Giá gửi xe?',
    'Còn chỗ trống không?',
    'Cách đặt chỗ?',
    'Địa chỉ bãi xe?',
    'Giờ mở cửa?',
  ];

  Widget _buildQuickSuggestions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: _bg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _chips.map((c) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                _controller.text = c;
                _sendMessage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.4)),
                ),
                child: Text(c,
                    style: const TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          const Text('Xin chào, bạn ơi!',
              style: TextStyle(color: _text, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Trợ lý AI thông minh đồng hành trên mọi chuyến đi',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 28),
          const Text('GỢI Ý CHO BẠN:',
              style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _chips.map((c) => GestureDetector(
              onTap: () {
                _controller.text = c;
                _sendMessage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _accent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, color: _accent, size: 14),
                    const SizedBox(width: 6),
                    Text(c, style: const TextStyle(color: _text, fontSize: 12)),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_Message msg, int index) {
    final isUser = msg.sender == _Sender.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? _accent : _surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: _border),
              ),
              child: Text(msg.text,
                  style: TextStyle(
                    color: isUser ? Colors.white : _text,
                    fontSize: 13.5,
                    height: 1.5,
                  )),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: _surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_rounded, color: _muted, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingBubble() {
    return _TypingBubble();
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: _text, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Bạn cần tôi giúp gì?',
                hintStyle: const TextStyle(color: _muted, fontSize: 14),
                filled: true,
                fillColor: _bg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _accent, width: 1.5),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _typing ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: _typing ? _surfaceLight : _accent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _typing ? Icons.hourglass_empty_rounded : Icons.send_rounded,
                color: _typing ? _muted : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Typing indicator
// ──────────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with TickerProviderStateMixin {
  late List<AnimationController> _ctrls;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(3, (i) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
          ..repeat(reverse: true, period: Duration(milliseconds: 800 + i * 150)));
  }

  @override
  void dispose() {
    for (final c in _ctrls) { c.dispose(); }
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
            width: 30, height: 30,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: _border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => AnimatedBuilder(
                animation: _ctrls[i],
                builder: (_, __) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 7,
                  height: 7 + _ctrls[i].value * 5,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.4 + _ctrls[i].value * 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
