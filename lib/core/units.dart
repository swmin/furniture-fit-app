import 'package:intl/intl.dart';

/// 길이 표시 단위. 기본값은 mm (PRD 확정 사항).
enum LengthUnit { mm, cm }

final _thousands = NumberFormat('#,##0');
final _oneDecimal = NumberFormat('#,##0.#');

/// mm 값을 사용자 표시 문자열로 변환한다. 예) 3600 → "3,600mm" / "360cm"
String formatLength(num mm, {LengthUnit unit = LengthUnit.mm}) =>
    switch (unit) {
      LengthUnit.mm => '${_thousands.format(mm.round())}mm',
      LengthUnit.cm => '${_oneDecimal.format(mm / 10)}cm',
    };

/// 가구 치수 문자열. 예) "1,500 × 2,000mm"
String formatSize(
  num widthMm,
  num depthMm, {
  LengthUnit unit = LengthUnit.mm,
}) => switch (unit) {
  LengthUnit.mm =>
    '${_thousands.format(widthMm.round())} × ${_thousands.format(depthMm.round())}mm',
  LengthUnit.cm =>
    '${_oneDecimal.format(widthMm / 10)} × ${_oneDecimal.format(depthMm / 10)}cm',
};

/// 면적 (m²). 예) 3600×4200 → "15.1m²"
String formatArea(num widthMm, num depthMm) =>
    '${_oneDecimal.format(widthMm * depthMm / 1e6)}m²';
