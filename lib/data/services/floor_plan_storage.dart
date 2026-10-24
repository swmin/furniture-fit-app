import 'dart:io';
import 'dart:ui' as ui;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// 저장된 도면 이미지 정보.
class StoredFloorPlan {
  const StoredFloorPlan({
    required this.relativePath,
    required this.widthPx,
    required this.heightPx,
  });

  final String relativePath;
  final int widthPx;
  final int heightPx;
}

/// 도면 이미지를 앱 문서 폴더(`plans/`)에 복사·조회·삭제한다.
///
/// DB에는 상대 경로만 저장해 앱 재설치/경로 변경에도 안전하게 한다.
class FloorPlanStorage {
  FloorPlanStorage({Future<Directory> Function()? baseDir})
    : _baseDir = baseDir ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _baseDir;

  Future<File> resolve(String relativePath) async =>
      File(p.join((await _baseDir()).path, relativePath));

  Future<StoredFloorPlan> save({
    required String sourcePath,
    required String homeId,
  }) async {
    final ext = p.extension(sourcePath).toLowerCase();
    final relative = p.join('plans', '$homeId${ext.isEmpty ? '.jpg' : ext}');
    final dest = await resolve(relative);
    await dest.parent.create(recursive: true);
    await File(sourcePath).copy(dest.path);

    final size = await _decodeSize(dest);
    return StoredFloorPlan(
      relativePath: relative,
      widthPx: size.$1,
      heightPx: size.$2,
    );
  }

  Future<void> delete(String relativePath) async {
    final f = await resolve(relativePath);
    if (await f.exists()) await f.delete();
  }

  Future<(int, int)> _decodeSize(File file) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      await file.readAsBytes(),
    );
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final size = (descriptor.width, descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return size;
  }
}
