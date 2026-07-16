import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Registers and returns an HtmlElementView embedding a Google Maps iframe.
Widget buildWebMapView(double lat, double lng) {
  const viewType = 'parking-map-iframe-v1';
  try {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int id) {
      final iframe = web.HTMLIFrameElement()
        ..src = 'https://maps.google.com/maps?q=$lat,$lng&z=16&output=embed'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      return iframe;
    });
  } catch (_) {
    // Factory already registered on hot reload — safe to ignore.
  }
  return const HtmlElementView(viewType: viewType);
}
