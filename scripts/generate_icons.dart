// ignore_for_file: avoid_print, dangling_library_doc_comments, depend_on_referenced_packages
/// Generates app icon PNG (1024x1024) using the `image` package.
/// Run: dart run scripts/generate_icons.dart

import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  print('Generating app icon (1024x1024)...');
  final icon = _generateAppIcon(1024);

  final iconPng = img.encodePng(icon);
  File('assets/icon/app_icon.png').writeAsBytesSync(iconPng);
  print('  -> assets/icon/app_icon.png (${iconPng.length} bytes)');

  // Also save as splash logo
  File('assets/splash/splash_logo.png').writeAsBytesSync(iconPng);
  print('  -> assets/splash/splash_logo.png');

  print('Done!');
}

img.Image _generateAppIcon(int size) {
  final image = img.Image(width: size, height: size);

  // Background gradient: top-left #5A9FE6 -> bottom-right #3A7BC8
  const r1 = 0x5A, g1 = 0x9F, b1 = 0xE6;
  const r2 = 0x3A, g2 = 0x7B, b2 = 0xC8;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final t = ((x + y) / (2 * size)).clamp(0.0, 1.0);
      final r = (r1 + (r2 - r1) * t).round();
      final g = (g1 + (g2 - g1) * t).round();
      final b = (b1 + (b2 - b1) * t).round();
      image.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // H mark dimensions
  final padding = size * 0.2;
  final logoArea = size - padding * 2;
  final h = logoArea * 0.85;
  final strokeW = h * 0.16;
  final cornerR = strokeW * 0.15;

  final cx = size / 2;
  final cy = size / 2;
  final leftX = cx - h * 0.35;
  final rightX = cx + h * 0.35 - strokeW;
  final topY = cy - h / 2;
  final bottomY = cy + h / 2;
  final crossbarY = topY + h * 0.43;

  // Draw H (white)
  _fillRoundedRect(image, leftX, topY, strokeW, bottomY - topY, cornerR, 255, 255, 255, 255);
  _fillRoundedRect(image, rightX, topY, strokeW, bottomY - topY, cornerR, 255, 255, 255, 255);
  _fillRoundedRect(image, leftX, crossbarY, rightX + strokeW - leftX, strokeW, cornerR, 255, 255, 255, 255);

  // Golden dot
  final dotDiam = h * 0.13;
  final dotR = dotDiam / 2;
  final dotCx = rightX + strokeW + dotR * 0.5;
  final dotCy = topY - dotR * 0.5;

  // Glow (soft radial falloff)
  _fillGlow(image, dotCx, dotCy, dotR * 2.5, 0xFF, 0xD5, 0x4F, 60);
  // Dot
  _fillCircle(image, dotCx, dotCy, dotR, 0xFF, 0xD5, 0x4F, 255);

  return image;
}

void _fillRoundedRect(img.Image image, double x, double y, double w, double h, double r, int red, int green, int blue, int alpha) {
  final x1 = x.round();
  final y1 = y.round();
  final x2 = (x + w).round();
  final y2 = (y + h).round();
  final ri = r.round();

  for (int py = y1; py < y2; py++) {
    for (int px = x1; px < x2; px++) {
      if (px < 0 || py < 0 || px >= image.width || py >= image.height) continue;
      // Check rounded corners
      if (_isInRoundedRect(px, py, x1, y1, x2, y2, ri)) {
        _blendPixel(image, px, py, red, green, blue, alpha);
      }
    }
  }
}

bool _isInRoundedRect(int px, int py, int x1, int y1, int x2, int y2, int r) {
  // Check if near a corner
  if (px < x1 + r && py < y1 + r) {
    return _dist(px, py, x1 + r, y1 + r) <= r;
  }
  if (px >= x2 - r && py < y1 + r) {
    return _dist(px, py, x2 - r, y1 + r) <= r;
  }
  if (px < x1 + r && py >= y2 - r) {
    return _dist(px, py, x1 + r, y2 - r) <= r;
  }
  if (px >= x2 - r && py >= y2 - r) {
    return _dist(px, py, x2 - r, y2 - r) <= r;
  }
  return true;
}

double _dist(int x1, int y1, int x2, int y2) {
  return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

void _fillCircle(img.Image image, double cx, double cy, double radius, int red, int green, int blue, int alpha) {
  final x1 = (cx - radius - 1).round();
  final y1 = (cy - radius - 1).round();
  final x2 = (cx + radius + 1).round();
  final y2 = (cy + radius + 1).round();

  for (int py = y1; py <= y2; py++) {
    for (int px = x1; px <= x2; px++) {
      if (px < 0 || py < 0 || px >= image.width || py >= image.height) continue;
      final d = math.sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
      if (d <= radius) {
        // Anti-alias at edge
        final edgeDist = radius - d;
        final a = edgeDist < 1.0 ? (alpha * edgeDist).round() : alpha;
        _blendPixel(image, px, py, red, green, blue, a);
      }
    }
  }
}

void _fillGlow(img.Image image, double cx, double cy, double radius, int red, int green, int blue, int maxAlpha) {
  final x1 = (cx - radius - 1).round();
  final y1 = (cy - radius - 1).round();
  final x2 = (cx + radius + 1).round();
  final y2 = (cy + radius + 1).round();

  for (int py = y1; py <= y2; py++) {
    for (int px = x1; px <= x2; px++) {
      if (px < 0 || py < 0 || px >= image.width || py >= image.height) continue;
      final d = math.sqrt((px - cx) * (px - cx) + (py - cy) * (py - cy));
      if (d <= radius) {
        // Soft falloff: full at center, zero at edge
        final t = 1.0 - (d / radius);
        final a = (maxAlpha * t * t).round(); // quadratic falloff
        if (a > 0) _blendPixel(image, px, py, red, green, blue, a);
      }
    }
  }
}

void _blendPixel(img.Image image, int x, int y, int r, int g, int b, int a) {
  if (a == 255) {
    image.setPixelRgba(x, y, r, g, b, 255);
    return;
  }
  if (a == 0) return;

  final existing = image.getPixel(x, y);
  final er = existing.r.toInt();
  final eg = existing.g.toInt();
  final eb = existing.b.toInt();
  final alpha = a / 255.0;
  final nr = (r * alpha + er * (1 - alpha)).round();
  final ng = (g * alpha + eg * (1 - alpha)).round();
  final nb = (b * alpha + eb * (1 - alpha)).round();
  image.setPixelRgba(x, y, nr, ng, nb, 255);
}
