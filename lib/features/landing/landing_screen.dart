import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/parking_brand_logo.dart';
import '../../shared/utils/responsive.dart';

import 'components/landing_hero.dart';
import 'components/landing_features.dart';
import 'components/landing_roles.dart';
import 'components/landing_workflow.dart';
import 'components/landing_demo.dart';
import 'components/landing_tech.dart';
import 'components/landing_about.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey rolesKey = GlobalKey();
  final GlobalKey workflowKey = GlobalKey();
  final GlobalKey demoKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFF06080F),
      body: SelectionArea(
        child: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70), // Navbar spacing
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
                      child: Column(
                        children: [
                          LandingHero(onExplorePressed: () => _scrollTo(featuresKey)),
                          Container(key: featuresKey, child: const LandingFeatures()),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(key: rolesKey, child: const LandingRoles()),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
                      child: Container(key: workflowKey, child: const LandingWorkflow()),
                    ),
                  ),
                ),
                Container(key: demoKey, child: const LandingDemo()),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
                      child: const LandingTech(),
                    ),
                  ),
                ),
                const LandingAboutCtaFooter(),
              ],
            ),
          ),

          // Fixed Navbar on top
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildNavbar(context, isMobile),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context, bool isMobile) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      decoration: BoxDecoration(
        color: const Color(0xFF06080F).withValues(alpha: 0.88),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const ParkingBrandLogo(size: 36),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ParkSmart', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                  Text('SWP08', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 2.2, color: Color(0xFF06B6D4), height: 1.1)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (!isMobile) ...[
                TextButton(onPressed: () => _scrollTo(featuresKey), child: const Text('Tính năng', style: TextStyle(color: Color(0xFF8492A6), fontSize: 13.5))),
                const SizedBox(width: 16),
                TextButton(onPressed: () => _scrollTo(rolesKey), child: const Text('Vai trò', style: TextStyle(color: Color(0xFF8492A6), fontSize: 13.5))),
                const SizedBox(width: 16),
                TextButton(onPressed: () => _scrollTo(workflowKey), child: const Text('Quy trình', style: TextStyle(color: Color(0xFF8492A6), fontSize: 13.5))),
                const SizedBox(width: 24),
                OutlinedButton(
                  onPressed: () => _scrollTo(demoKey),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF7C3AED).withValues(alpha: 0.35)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Xem demo', style: TextStyle(color: Color(0xFFA78BFA), fontSize: 13)),
                ),
                const SizedBox(width: 8),
              ],
              ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.login_rounded, size: 16, color: Colors.white),
                label: const Text('Khám phá ngay', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
