import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

/// 축척 보정 정보: 도면 이미지 위 두 점(px)과 그 실제 길이(mm).
class Calibration {
  const Calibration({
    required this.p1,
    required this.p2,
    required this.lengthMm,
  });

  final Offset p1;
  final Offset p2;
  final int lengthMm;

  double get distancePx => (p2 - p1).distance;

  /// 이미지 1px 당 실제 mm. 두 점이 너무 가까우면 null.
  double? get mmPerPixel =>
      distancePx < minDistancePx ? null : lengthMm / distancePx;

  /// 정확도를 위해 기준선은 최소 이 길이(px) 이상이어야 한다.
  static const minDistancePx = 20.0;

  String toJson() => jsonEncode({
    'p1': [p1.dx, p1.dy],
    'p2': [p2.dx, p2.dy],
    'lengthMm': lengthMm,
  });

  static Calibration? tryParse(String? raw) {
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      Offset pt(String k) {
        final l = (m[k] as List).cast<num>();
        return Offset(l[0].toDouble(), l[1].toDouble());
      }

      return Calibration(
        p1: pt('p1'),
        p2: pt('p2'),
        lengthMm: (m['lengthMm'] as num).toInt(),
      );
    } catch (_) {
      return null;
    }
  }

  /// 기준선 각도(도). 수평/수직 스냅 안내에 사용.
  double get angleDeg =>
      math.atan2(p2.dy - p1.dy, p2.dx - p1.dx) * 180 / math.pi;
}
