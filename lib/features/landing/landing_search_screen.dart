import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/mock_data_service.dart';
import 'landing_screen.dart';

// ignore: avoid_web_libraries_in_flutter
import '../driver/map_screen_web.dart'
    if (dart.library.io) '../driver/map_screen_stub.dart';

const _landingBg = Color(0xFFF8FAFC);
const _landingSurface = Color(0xFFFFFFFF);
const _landingBorder = Color(0xFFE2E8F0);
const _landingMuted = Color(0xFF64748B);
const _landingText = Color(0xFF0F172A);
const _landingAccent = Color(0xFF10B981);
const _landingAccentLight = Color(0xFFECFDF5);
const _lat = 10.7285;
const _lng = 106.7127;

class LandingSearchScreen extends StatefulWidget {
  const LandingSearchScreen({super.key});

  @override
  State<LandingSearchScreen> createState() => _LandingSearchScreenState();
}

class _LandingSearchScreenState extends State<LandingSearchScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'Sẵn'; // Tất cả | Sẵn | Gần | Rate | Lợi
  double _radius = 3.0;
  bool _availableOnly = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: _landingBg,
      body: Column(
        children: [
          // Navbar (full-width, on top)
          LandingNavbar(
            activePage: 'search',
            onLogin: () => context.go('/login'),
          ),

          // Body below navbar
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
        // ── Left Panel (270px fixed)
        Container(
          width: 270,
          decoration: const BoxDecoration(
            color: _landingSurface,
            border: Border(right: BorderSide(color: _landingBorder)),
          ),
          child: _LeftSearchPanel(
            searchCtrl: _searchCtrl,
            filter: _filter,
            radius: _radius,
            availableOnly: _availableOnly,
            onFilterChanged: (f) => setState(() => _filter = f),
            onRadiusChanged: (r) => setState(() => _radius = r),
            onAvailableChanged: (v) => setState(() => _availableOnly = v),
          ),
        ),

        // ── Right: Map
        Expanded(child: _buildMapArea()),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        // Search bar + filter bar on top
        Container(
          color: _landingSurface,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: _SearchBar(controller: _searchCtrl),
        ),
        const Divider(height: 1, color: _landingBorder),
        // Map and List
        Expanded(flex: 2, child: _buildMapArea()),
        Expanded(
          flex: 3,
          child: Container(
            color: _landingSurface,
            child: _LeftSearchPanel(
              searchCtrl: _searchCtrl,
              filter: _filter,
              radius: _radius,
              availableOnly: _availableOnly,
              onFilterChanged: (f) => setState(() => _filter = f),
              onRadiusChanged: (r) => setState(() => _radius = r),
              onAvailableChanged: (v) => setState(() => _availableOnly = v),
              showSearchBar: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapArea() {
    return Stack(
      children: [
        // Map
        Positioned.fill(
          child: buildWebMapView(_lat, _lng),
        ),

        // Top-right: my location button
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 2))
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.my_location_rounded, color: _landingAccent, size: 20),
              tooltip: 'Vị trí của tôi',
              onPressed: () {},
            ),
          ),
        ),

        // Bottom: CTA banner if not logged in
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 6))
                ],
                border: Border.all(color: _landingAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: _landingAccent, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Đăng ký để đặt chỗ trước và nhận ưu đãi gửi xe tháng.',
                      style: TextStyle(color: _landingText, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _landingAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Đăng ký', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Left search panel
// ──────────────────────────────────────────────
class _LeftSearchPanel extends StatelessWidget {
  final TextEditingController searchCtrl;
  final String filter;
  final double radius;
  final bool availableOnly;
  final bool showSearchBar;
  final void Function(String) onFilterChanged;
  final void Function(double) onRadiusChanged;
  final void Function(bool) onAvailableChanged;

  const _LeftSearchPanel({
    required this.searchCtrl,
    required this.filter,
    required this.radius,
    required this.availableOnly,
    required this.onFilterChanged,
    required this.onRadiusChanged,
    required this.onAvailableChanged,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSearchBar) ...[
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: _SearchBar(controller: searchCtrl),
          ),
          const Divider(height: 24, color: _landingBorder),
        ],

        // Results header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('KẾT QUẢ',
              style: TextStyle(color: _landingMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        ),
        const SizedBox(height: 8),

        // Parking result card
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: const [
              _ParkingResultCard(
                name: 'Bãi Xe SWP08 – Q.7',
                address: '123 Nguyễn Văn Linh, Q.7',
                distance: '2.5 km',
                available: 86,
                total: 145,
                price: '5k–15k/giờ',
                rating: 4.7,
                isHighlighted: true,
              ),
              SizedBox(height: 10),
              _ParkingResultCard(
                name: 'Bãi Xe Hầm Crescent Mall',
                address: '101 Tôn Dật Tiên, Q.7',
                distance: '3.1 km',
                available: 24,
                total: 80,
                price: '10k–20k/giờ',
                rating: 4.3,
              ),
              SizedBox(height: 10),
              _ParkingResultCard(
                name: 'Bãi Xe Gigamall',
                address: 'Phạm Văn Đồng, Thủ Đức',
                distance: '4.8 km',
                available: 0,
                total: 60,
                price: '5k–12k/giờ',
                rating: 4.1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: _landingText, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm địa điểm với ParkWave',
        hintStyle: const TextStyle(color: _landingMuted, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: _landingMuted, size: 18),
        suffixIcon: IconButton(
          icon: const Icon(Icons.my_location_rounded, color: _landingAccent, size: 18),
          onPressed: () {
            controller.text = 'Vị trí hiện tại';
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _landingBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _landingBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _landingAccent, width: 1.5),
        ),
      ),
    );
  }
}



class _ParkingResultCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final int available;
  final int total;
  final String price;
  final double rating;
  final bool isHighlighted;

  const _ParkingResultCard({
    required this.name,
    required this.address,
    required this.distance,
    required this.available,
    required this.total,
    required this.price,
    required this.rating,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? available / total : 0.0;
    final statusColor = available == 0
        ? const Color(0xFFEF4444)
        : pct < 0.3
            ? const Color(0xFFFBBF24)
            : _landingAccent;

    final isLoggedIn = context.watch<MockDataService>().currentUser != null;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Stack(
            fit: StackFit.expand,
            children: [
              if (kIsWeb) buildPointerInterceptor(),
              Center(
                child: AlertDialog(
                  backgroundColor: _landingSurface,
            titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black))),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: _landingMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📍 Địa chỉ: $address', style: const TextStyle(fontSize: 13, height: 1.5)),
                const SizedBox(height: 8),
                Text('🚗 Khoảng cách: $distance', style: const TextStyle(fontSize: 13, height: 1.5)),
                const SizedBox(height: 8),
                Text('💰 Giá: $price', style: const TextStyle(fontSize: 13, height: 1.5)),
                const SizedBox(height: 8),
                Text('🅿️ Chỗ trống: $available/$total', style: const TextStyle(fontSize: 13, height: 1.5)),
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🚗 Ô tô: ${(available * 0.3).round()} chỗ', style: const TextStyle(fontSize: 12, color: _landingMuted)),
                      Text('🛵 Xe máy: ${(available * 0.6).round()} chỗ', style: const TextStyle(fontSize: 12, color: _landingMuted)),
                      Text('🚚 Xe tải: ${(available * 0.1).round()} chỗ', style: const TextStyle(fontSize: 12, color: _landingMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('⭐ Đánh giá: $rating / 5.0', style: const TextStyle(fontSize: 13, height: 1.5)),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _landingAccent,
                        side: const BorderSide(color: _landingAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Dẫn đường', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (!isLoggedIn) {
                          context.go('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _landingAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Đặt chỗ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ), // Close Center
      ],
    ), // Close Stack
  );
},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHighlighted ? _landingAccentLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? _landingAccent.withValues(alpha: 0.5) : _landingBorder,
            width: isHighlighted ? 1.5 : 1,
          ),
          boxShadow: isHighlighted
              ? [BoxShadow(color: _landingAccent.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 13),
                    const SizedBox(width: 2),
                    Text('$rating', style: const TextStyle(color: _landingText, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(address, style: const TextStyle(color: _landingMuted, fontSize: 11)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.directions_car_outlined, color: _landingMuted, size: 13),
                const SizedBox(width: 4),
                Text(distance, style: const TextStyle(color: _landingMuted, fontSize: 11)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    available == 0 ? 'Hết chỗ' : '$available/$total trống',
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: const TextStyle(color: _landingMuted, fontSize: 11)),
                if (available > 0)
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _landingAccent,
                          side: const BorderSide(color: _landingAccent),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          minimumSize: const Size(0, 28),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Dẫn đường', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (!isLoggedIn) {
                            context.go('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _landingAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          minimumSize: const Size(0, 28),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Đặt chỗ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
