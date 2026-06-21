import 'package:flutter/material.dart';

class ParkingBrandLogo extends StatelessWidget {
  final double size;

  const ParkingBrandLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
        ),
        borderRadius: BorderRadius.circular(size * 0.27),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.28),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Icon(
              Icons.local_parking_rounded,
              color: Colors.white,
              size: size * 0.64,
            ),
          ),
          Positioned(
            right: size * 0.1,
            bottom: size * 0.1,
            child: Container(
              width: size * 0.32,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(size * 0.09),
                border: Border.all(
                  color: Colors.white.withOpacity(0.85),
                  width: size * 0.025,
                ),
              ),
              child: Icon(
                Icons.directions_car_rounded,
                color: const Color(0xFF34D399),
                size: size * 0.18,
              ),
            ),
          ),
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: size * 0.025),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
