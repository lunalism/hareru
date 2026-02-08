import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/ocr_service.dart';

class ReceiptScanPage extends StatefulWidget {
  const ReceiptScanPage({super.key});

  @override
  State<ReceiptScanPage> createState() => _ReceiptScanPageState();
}

enum _CameraState { loading, ready, error }

class _ReceiptScanPageState extends State<ReceiptScanPage> {
  CameraController? _controller;
  _CameraState _cameraState = _CameraState.loading;
  bool _flashOn = false;
  bool _isProcessing = false;
  final _ocrService = OcrService();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraState = _CameraState.error);
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }

      _controller = controller;
      setState(() => _cameraState = _CameraState.ready);
    } catch (_) {
      if (mounted) setState(() => _cameraState = _CameraState.error);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isProcessing || _controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);
    try {
      final xFile = await _controller!.takePicture();
      if (!mounted) return;
      await _processImage(xFile.path);
    } catch (_) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError(AppLocalizations.of(context)!.ocrFailed);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        if (mounted) setState(() => _isProcessing = false);
        return;
      }
      if (!mounted) return;
      await _processImage(xFile.path);
    } catch (_) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError(AppLocalizations.of(context)!.ocrFailed);
      }
    }
  }

  Future<void> _processImage(String imagePath) async {
    try {
      final result = await _ocrService.processReceipt(imagePath);
      if (!mounted) return;

      setState(() => _isProcessing = false);
      context.push('/input/receipt/result', extra: {
        'imagePath': imagePath,
        'amount': result.amount,
        'storeName': result.storeName,
        'date': result.date,
        'rawText': result.rawText,
        'confidence': result.confidence,
      });
    } catch (_) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showError(AppLocalizations.of(context)!.ocrFailed);
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    try {
      _flashOn = !_flashOn;
      await _controller!.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    } catch (_) {
      // Flash not supported
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'PretendardJP')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.receiptScanTitle,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera preview or fallback
          _buildCameraArea(l10n),

          // Guide frame overlay
          if (_cameraState == _CameraState.ready) _buildGuideOverlay(l10n),

          // Bottom controls
          _buildControls(l10n),

          // Processing overlay
          if (_isProcessing) _buildProcessingOverlay(l10n),
        ],
      ),
    );
  }

  Widget _buildCameraArea(AppLocalizations l10n) {
    switch (_cameraState) {
      case _CameraState.loading:
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      case _CameraState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt_rounded, size: 48, color: Colors.white54),
                const SizedBox(height: 16),
                Text(
                  l10n.cameraInitFailed,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PretendardJP',
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library_rounded, size: 20),
                  label: Text(
                    l10n.gallery,
                    style: const TextStyle(fontFamily: 'PretendardJP', fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        );
      case _CameraState.ready:
        return Positioned.fill(
          child: CameraPreview(_controller!),
        );
    }
  }

  Widget _buildGuideOverlay(AppLocalizations l10n) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GuideFramePainter(),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  l10n.receiptScanGuide,
                  style: const TextStyle(
                    fontFamily: 'PretendardJP',
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(AppLocalizations l10n) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 32,
          right: 32,
          top: 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Gallery button
            _ControlButton(
              icon: Icons.photo_library_rounded,
              label: l10n.gallery,
              onTap: _pickFromGallery,
            ),

            // Capture button
            GestureDetector(
              onTap: _cameraState == _CameraState.ready ? _takePicture : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Flash toggle
            _ControlButton(
              icon: _flashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              label: l10n.flash,
              onTap: _cameraState == _CameraState.ready ? _toggleFlash : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay(AppLocalizations l10n) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              Text(
                l10n.scanning,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a semi-transparent overlay with a clear receipt guide frame.
class _GuideFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final frameWidth = size.width * 0.85;
    final frameHeight = size.height * 0.55;
    final left = (size.width - frameWidth) / 2;
    final top = (size.height - frameHeight) / 2 - 20; // Shift up slightly

    final frameRect = Rect.fromLTWH(left, top, frameWidth, frameHeight);

    // Draw semi-transparent overlay outside the frame
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.4);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(frameRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    // Draw corner brackets
    const cornerLength = 24.0;
    const cornerWidth = 3.0;
    final cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rr = RRect.fromRectAndRadius(frameRect, const Radius.circular(12));

    // Top-left
    canvas.drawLine(Offset(rr.left, rr.top + cornerLength), Offset(rr.left, rr.top + 6), cornerPaint);
    canvas.drawLine(Offset(rr.left, rr.top), Offset(rr.left + cornerLength, rr.top), cornerPaint);

    // Top-right
    canvas.drawLine(Offset(rr.right - cornerLength, rr.top), Offset(rr.right, rr.top), cornerPaint);
    canvas.drawLine(Offset(rr.right, rr.top), Offset(rr.right, rr.top + cornerLength), cornerPaint);

    // Bottom-left
    canvas.drawLine(Offset(rr.left, rr.bottom - cornerLength), Offset(rr.left, rr.bottom), cornerPaint);
    canvas.drawLine(Offset(rr.left, rr.bottom), Offset(rr.left + cornerLength, rr.bottom), cornerPaint);

    // Bottom-right
    canvas.drawLine(Offset(rr.right - cornerLength, rr.bottom), Offset(rr.right, rr.bottom), cornerPaint);
    canvas.drawLine(Offset(rr.right, rr.bottom - cornerLength), Offset(rr.right, rr.bottom), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
