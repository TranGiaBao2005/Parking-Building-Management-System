import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CameraPlateScanner extends StatelessWidget {
  final String samplePlate;
  final ValueChanged<String> onDetected;

  const CameraPlateScanner({
    super.key,
    required this.samplePlate,
    required this.onDetected,
  });

  @override
  Widget build(BuildContext context) {
    return _AlwaysOnCamera(
      samplePlate: samplePlate,
      onDetected: onDetected,
    );
  }
}

class _AlwaysOnCamera extends StatefulWidget {
  final String samplePlate;
  final ValueChanged<String> onDetected;

  const _AlwaysOnCamera({
    required this.samplePlate,
    required this.onDetected,
  });

  @override
  State<_AlwaysOnCamera> createState() => _AlwaysOnCameraState();
}

class _AlwaysOnCameraState extends State<_AlwaysOnCamera> {
  bool _detected = false;

  @override
  void initState() {
    super.initState();
    _startDetection();
  }

  @override
  void didUpdateWidget(covariant _AlwaysOnCamera oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.samplePlate != widget.samplePlate) {
      _detected = false;
      _startDetection();
    }
  }

  Future<void> _startDetection() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || _detected) return;
    setState(() => _detected = true);
    widget.onDetected(widget.samplePlate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.available.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.available.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      _detected ? AppColors.available : AppColors.borderLight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.videocam_outlined,
                      color: Colors.white24, size: 48),
                  FractionallySizedBox(
                    widthFactor: 0.68,
                    heightFactor: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.available, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 9,
                    child: Text(
                      _detected
                          ? 'Đã nhận diện: ${widget.samplePlate}'
                          : 'Camera đang tự động quét...',
                      style: TextStyle(
                        color: _detected ? AppColors.available : Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                _detected ? Icons.check_circle : Icons.camera_alt_outlined,
                color: AppColors.available,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _detected
                      ? 'Biển số đã được tự động điền vào biểu mẫu'
                      : 'Camera luôn mở và tự nhận diện biển số',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
              if (!_detected)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: AppColors.available,
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
