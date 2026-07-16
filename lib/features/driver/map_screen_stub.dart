import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Renders Google Maps via WebView on non-web platforms (Android/iOS)
Widget buildWebMapView(double lat, double lng) {
  return _MobileMapWebView(lat: lat, lng: lng);
}

/// Stub for non-web platforms.
Widget buildPointerInterceptor() {
  return const SizedBox.shrink();
}

class _MobileMapWebView extends StatefulWidget {
  final double lat;
  final double lng;
  const _MobileMapWebView({required this.lat, required this.lng});

  @override
  State<_MobileMapWebView> createState() => _MobileMapWebViewState();
}

class _MobileMapWebViewState extends State<_MobileMapWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://maps.google.com/maps?q=${widget.lat},${widget.lng}&z=16&output=embed'));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
