import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 600;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide < mobileBreakpoint;

  static bool isDesktop(BuildContext context) => !isMobile(context);
}

/// Adaptive sizing utility.
/// All sizes are defined relative to a 390x844 base design
/// (equivalent to iPhone 14 / most modern Android phones in logical pixels).
/// At 1080x2400 physical pixels with a ~2.75x pixel ratio → ~393x873 logical px.
class ScreenUtils {
  // Base design dimensions (logical pixels)
  static const double _baseWidth = 390.0;
  static const double _baseHeight = 844.0;

  static late double _screenWidth;
  static late double _screenHeight;
  static late double _scaleW;
  static late double _scaleH;
  static late double _scaleText;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    _screenWidth = size.width;
    _screenHeight = size.height;
    _scaleW = _screenWidth / _baseWidth;
    _scaleH = _screenHeight / _baseHeight;
    // Text scale factor capped between 0.8–1.2 to avoid extreme sizes
    _scaleText = (_scaleW * (1.0 / textScale)).clamp(0.8, 1.2);
  }

  /// Scale a horizontal dimension (width, horizontal padding)
  static double sw(double size) => size * _scaleW;

  /// Scale a vertical dimension (height, vertical padding)
  static double sh(double size) => size * _scaleH;

  /// Scale a font size
  static double sp(double size) => size * _scaleText;

  /// Scale padding symmetrically (uses width scale)
  static double p(double size) => size * _scaleW;

  /// Responsive horizontal padding for screens
  static double get screenPaddingH =>
      _screenWidth < 400 ? 16.0 * _scaleW : 20.0 * _scaleW;

  /// Responsive vertical padding for screens
  static double get screenPaddingV => 16.0 * _scaleH;

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
}
