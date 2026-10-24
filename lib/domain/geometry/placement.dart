import 'dart:math' as math;
import 'dart:ui';

/// 회전된 직사각형 (가구 1개). 모든 값은 mm 월드 좌표.
///
/// 로컬 좌표계: 중심이 원점, +x = 가구 가로(폭) 방향, +y = 가구 앞쪽(문이 열리는 쪽).
class FurnitureRect {
  const FurnitureRect({
    required this.center,
    required this.width,
    required this.depth,
    this.rotationDeg = 0,
  });

  final Offset center;
  final double width;
  final double depth;
  final double rotationDeg;

  double get rad => rotationDeg * math.pi / 180;

  /// 로컬 좌표 → 월드 좌표.
  Offset toWorld(Offset local) {
    final c = math.cos(rad), s = math.sin(rad);
    return center +
        Offset(local.dx * c - local.dy * s, local.dx * s + local.dy * c);
  }

  /// 월드 좌표 → 로컬 좌표.
  Offset toLocal(Offset world) {
    final p = world - center;
    final c = math.cos(-rad), s = math.sin(-rad);
    return Offset(p.dx * c - p.dy * s, p.dx * s + p.dy * c);
  }

  List<Offset> get corners => [
    toWorld(Offset(-width / 2, -depth / 2)),
    toWorld(Offset(width / 2, -depth / 2)),
    toWorld(Offset(width / 2, depth / 2)),
    toWorld(Offset(-width / 2, depth / 2)),
  ];

  /// 축 정렬 외접 사각형.
  Rect get bounds {
    final cs = corners;
    var l = cs.first.dx, r = l, t = cs.first.dy, b = t;
    for (final p in cs.skip(1)) {
      l = math.min(l, p.dx);
      r = math.max(r, p.dx);
      t = math.min(t, p.dy);
      b = math.max(b, p.dy);
    }
    return Rect.fromLTRB(l, t, r, b);
  }

  bool contains(Offset world, {double slop = 0}) {
    final p = toLocal(world);
    return p.dx.abs() <= width / 2 + slop && p.dy.abs() <= depth / 2 + slop;
  }

  /// 분리축 정리(SAT)로 겹침 판정. 변이 맞닿는 것(간격 0)은 겹침이 아니다.
  bool overlaps(FurnitureRect other, {double tolerance = 0.5}) {
    final a = corners, b = other.corners;
    for (final axis in [..._axes(a), ..._axes(b)]) {
      final (minA, maxA) = _project(a, axis);
      final (minB, maxB) = _project(b, axis);
      if (maxA <= minB + tolerance || maxB <= minA + tolerance) return false;
    }
    return true;
  }

  FurnitureRect copyWith({Offset? center, double? rotationDeg}) =>
      FurnitureRect(
        center: center ?? this.center,
        width: width,
        depth: depth,
        rotationDeg: rotationDeg ?? this.rotationDeg,
      );

  static List<Offset> _axes(List<Offset> cs) {
    final e1 = cs[1] - cs[0], e2 = cs[3] - cs[0];
    return [e1 / e1.distance, e2 / e2.distance];
  }

  static (double, double) _project(List<Offset> cs, Offset axis) {
    var mn = double.infinity, mx = double.negativeInfinity;
    for (final p in cs) {
      final v = p.dx * axis.dx + p.dy * axis.dy;
      mn = math.min(mn, v);
      mx = math.max(mx, v);
    }
    return (mn, mx);
  }
}

/// 문 한 짝 (로컬 좌표, mm). 경첩 위치와 문 폭.
class DoorLeaf {
  const DoorLeaf({
    required this.hingeX,
    required this.length,
    required this.opensToRight,
  });

  /// 앞면(y = depth/2) 위 경첩의 로컬 x.
  final double hingeX;
  final double length;

  /// true면 경첩에서 +x 방향으로 문이 닫혀 있다.
  final bool opensToRight;
}

/// 문/서랍 열림 정보로부터 문짝 목록과 열림 공간을 계산한다.
class DoorGeometry {
  DoorGeometry._(this.type, this.leaves, this.zoneDepth);

  /// 'single' | 'double' | 'drawer'
  final String type;
  final List<DoorLeaf> leaves;

  /// 앞면에서 바깥으로 필요한 공간 깊이(mm).
  final double zoneDepth;

  static DoorGeometry? of(String? type, int? swingMm, double width) {
    if (type == null || swingMm == null || swingMm <= 0) return null;
    switch (type) {
      case 'single':
        final l = math.min(swingMm.toDouble(), width);
        return DoorGeometry._(type, [
          DoorLeaf(hingeX: -width / 2, length: l, opensToRight: true),
        ], l);
      case 'double':
        final n = math.max(1, (width / swingMm).round());
        final l = width / n;
        final leaves = <DoorLeaf>[];
        for (var i = 0; i < n; i++) {
          final x0 = -width / 2 + i * l;
          // 짝수 번째는 왼쪽 경첩, 홀수 번째는 오른쪽 경첩 (양문형).
          leaves.add(
            i.isEven
                ? DoorLeaf(hingeX: x0, length: l, opensToRight: true)
                : DoorLeaf(hingeX: x0 + l, length: l, opensToRight: false),
          );
        }
        return DoorGeometry._(type, leaves, l);
      case 'drawer':
        return DoorGeometry._(type, const [], swingMm.toDouble());
    }
    return null;
  }

  /// 앞면 앞쪽의 열림 공간 (월드 좌표 회전 사각형).
  FurnitureRect zone(FurnitureRect item) {
    final localCenter = Offset(0, item.depth / 2 + zoneDepth / 2);
    return FurnitureRect(
      center: item.toWorld(localCenter),
      width: item.width,
      depth: zoneDepth,
      rotationDeg: item.rotationDeg,
    );
  }
}

/// 선택한 가구에서 한 방향으로 가장 가까운 장애물(벽·가구)까지의 간격.
class Gap {
  const Gap({
    required this.from,
    required this.to,
    required this.mm,
    required this.toWall,
  });

  final Offset from;
  final Offset to;
  final double mm;
  final bool toWall;
}

/// 축 정렬 외접 사각형 기준으로 상하좌우 간격을 계산한다.
///
/// [room]이 있으면 방 벽까지의 거리도 후보에 포함한다.
List<Gap> computeGaps(Rect a, Iterable<Rect> obstacles, {Rect? room}) {
  const eps = 0.5;
  final result = <Gap>[];

  Gap? best;
  void consider(Gap g) {
    if (g.mm < -eps) return;
    if (best == null || g.mm < best!.mm) best = g;
  }

  double midY(Rect o) =>
      (math.max(a.top, o.top) + math.min(a.bottom, o.bottom)) / 2;
  double midX(Rect o) =>
      (math.max(a.left, o.left) + math.min(a.right, o.right)) / 2;
  bool overlapY(Rect o) => o.top < a.bottom - eps && o.bottom > a.top + eps;
  bool overlapX(Rect o) => o.left < a.right - eps && o.right > a.left + eps;

  // → 오른쪽
  best = null;
  for (final o in obstacles) {
    if (overlapY(o) && o.left >= a.right - eps) {
      final y = midY(o);
      consider(
        Gap(
          from: Offset(a.right, y),
          to: Offset(o.left, y),
          mm: o.left - a.right,
          toWall: false,
        ),
      );
    }
  }
  if (room != null && a.right <= room.right + eps) {
    consider(
      Gap(
        from: Offset(a.right, a.center.dy),
        to: Offset(room.right, a.center.dy),
        mm: room.right - a.right,
        toWall: true,
      ),
    );
  }
  if (best != null) result.add(best!);

  // ← 왼쪽
  best = null;
  for (final o in obstacles) {
    if (overlapY(o) && o.right <= a.left + eps) {
      final y = midY(o);
      consider(
        Gap(
          from: Offset(a.left, y),
          to: Offset(o.right, y),
          mm: a.left - o.right,
          toWall: false,
        ),
      );
    }
  }
  if (room != null && a.left >= room.left - eps) {
    consider(
      Gap(
        from: Offset(a.left, a.center.dy),
        to: Offset(room.left, a.center.dy),
        mm: a.left - room.left,
        toWall: true,
      ),
    );
  }
  if (best != null) result.add(best!);

  // ↓ 아래
  best = null;
  for (final o in obstacles) {
    if (overlapX(o) && o.top >= a.bottom - eps) {
      final x = midX(o);
      consider(
        Gap(
          from: Offset(x, a.bottom),
          to: Offset(x, o.top),
          mm: o.top - a.bottom,
          toWall: false,
        ),
      );
    }
  }
  if (room != null && a.bottom <= room.bottom + eps) {
    consider(
      Gap(
        from: Offset(a.center.dx, a.bottom),
        to: Offset(a.center.dx, room.bottom),
        mm: room.bottom - a.bottom,
        toWall: true,
      ),
    );
  }
  if (best != null) result.add(best!);

  // ↑ 위
  best = null;
  for (final o in obstacles) {
    if (overlapX(o) && o.bottom <= a.top + eps) {
      final x = midX(o);
      consider(
        Gap(
          from: Offset(x, a.top),
          to: Offset(x, o.bottom),
          mm: a.top - o.bottom,
          toWall: false,
        ),
      );
    }
  }
  if (room != null && a.top >= room.top - eps) {
    consider(
      Gap(
        from: Offset(a.center.dx, a.top),
        to: Offset(a.center.dx, room.top),
        mm: a.top - room.top,
        toWall: true,
      ),
    );
  }
  if (best != null) result.add(best!);

  return result;
}

/// 드래그 중 가장자리를 벽/다른 가구 가장자리에 붙이기 위한 이동량.
///
/// [tolerance] 이내의 가장 가까운 가장자리로 맞춘다. 없으면 0.
Offset snapDelta(
  Rect a, {
  required List<double> xEdges,
  required List<double> yEdges,
  required double tolerance,
}) {
  double axis(double lo, double hi, List<double> edges) {
    double? best;
    for (final e in edges) {
      for (final d in [e - lo, e - hi]) {
        if (d.abs() <= tolerance && (best == null || d.abs() < best.abs())) {
          best = d;
        }
      }
    }
    return best ?? 0;
  }

  return Offset(axis(a.left, a.right, xEdges), axis(a.top, a.bottom, yEdges));
}

/// 회전 각도 스냅: 5° 단위, 0/90/180/270° 근처(±4°)는 정확히 맞춤.
double snapAngle(double deg) {
  var d = deg % 360;
  if (d < 0) d += 360;
  for (final right in [0.0, 90.0, 180.0, 270.0, 360.0]) {
    if ((d - right).abs() <= 4) return right % 360;
  }
  return ((d / 5).round() * 5) % 360;
}
