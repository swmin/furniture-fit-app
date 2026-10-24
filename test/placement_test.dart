import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:furniturefit/domain/geometry/placement.dart';

void main() {
  group('FurnitureRect', () {
    test('90° 회전 시 외접 사각형의 가로/세로가 바뀐다', () {
      const r = FurnitureRect(
        center: Offset(1000, 1000),
        width: 1500,
        depth: 2000,
        rotationDeg: 90,
      );
      final b = r.bounds;
      expect(b.width, closeTo(2000, 0.01));
      expect(b.height, closeTo(1500, 0.01));
    });

    test('맞닿은 가구는 겹침이 아니고, 1mm라도 들어가면 겹침', () {
      const a = FurnitureRect(
        center: Offset(500, 500),
        width: 1000,
        depth: 1000,
      );
      const touching = FurnitureRect(
        center: Offset(1500, 500),
        width: 1000,
        depth: 1000,
      );
      const intruding = FurnitureRect(
        center: Offset(1499, 500),
        width: 1000,
        depth: 1000,
      );
      expect(a.overlaps(touching), isFalse);
      expect(a.overlaps(intruding), isTrue);
    });

    test('45° 회전 사각형: 외접 사각형은 겹쳐도 실제로는 안 겹치는 경우', () {
      const diamond = FurnitureRect(
        center: Offset(0, 0),
        width: 1000,
        depth: 1000,
        rotationDeg: 45,
      );
      // 다이아몬드 꼭짓점 사이 모서리 쪽 빈 공간에 작은 상자
      const corner = FurnitureRect(
        center: Offset(600, 600),
        width: 200,
        depth: 200,
      );
      expect(diamond.bounds.overlaps(corner.bounds), isTrue);
      expect(diamond.overlaps(corner), isFalse);
    });

    test('contains는 회전을 고려한다', () {
      const r = FurnitureRect(
        center: Offset(0, 0),
        width: 2000,
        depth: 200,
        rotationDeg: 90,
      );
      expect(r.contains(const Offset(0, 900)), isTrue);
      expect(r.contains(const Offset(900, 0)), isFalse);
    });
  });

  group('DoorGeometry', () {
    test('장롱 1200 / 문폭 300 → 4짝, 열림 공간 깊이 300', () {
      final d = DoorGeometry.of('double', 300, 1200)!;
      expect(d.leaves, hasLength(4));
      expect(d.zoneDepth, 300);
    });

    test('문 열림 공간은 가구 앞쪽(로컬 +y)에 생긴다', () {
      const item = FurnitureRect(center: Offset(0, 0), width: 900, depth: 700);
      final zone = DoorGeometry.of('double', 450, 900)!.zone(item);
      expect(zone.center.dy, closeTo(350 + 225, 0.01));
      // 180° 회전하면 반대쪽
      final flipped = DoorGeometry.of(
        'double',
        450,
        900,
      )!.zone(item.copyWith(rotationDeg: 180));
      expect(flipped.center.dy, closeTo(-(350 + 225), 0.01));
    });

    test('문 정보가 없으면 null', () {
      expect(DoorGeometry.of(null, null, 1000), isNull);
    });
  });

  group('computeGaps', () {
    const room = Rect.fromLTWH(0, 0, 3600, 4200);

    test('빈 방에서는 네 벽까지의 거리', () {
      final gaps = computeGaps(
        const Rect.fromLTWH(1000, 1000, 1500, 2000),
        const [],
        room: room,
      );
      final mm = gaps.map((g) => g.mm.round()).toList()..sort();
      expect(mm, [1000, 1000, 1100, 1200]);
      expect(gaps.every((g) => g.toWall), isTrue);
    });

    test('가구가 벽보다 가까우면 가구까지의 거리', () {
      final gaps = computeGaps(const Rect.fromLTWH(0, 0, 1000, 1000), const [
        Rect.fromLTWH(1600, 200, 500, 500),
      ], room: room);
      final right = gaps.firstWhere((g) => g.to.dx > g.from.dx);
      expect(right.mm, 600);
      expect(right.toWall, isFalse);
    });
  });

  test('snapDelta: 허용 범위 안의 가장 가까운 가장자리로 맞춘다', () {
    final d = snapDelta(
      const Rect.fromLTWH(15, 500, 1000, 1000),
      xEdges: [0, 3600],
      yEdges: [0, 4200],
      tolerance: 20,
    );
    expect(d, const Offset(-15, 0));
  });

  test('snapAngle', () {
    expect(snapAngle(92), 90);
    expect(snapAngle(-3), 0);
    expect(snapAngle(33), 35);
    expect(snapAngle(358), 0);
  });
}
