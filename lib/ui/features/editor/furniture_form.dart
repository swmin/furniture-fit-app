import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/repositories/layout_repository.dart';

/// 가구 색상 팔레트.
const furniturePalette = <int>[
  0xFFA1887F, 0xFF8D6E63, 0xFFBCAAA4, 0xFFD7CCC8, //
  0xFF7986CB, 0xFF4DB6AC, 0xFFFFCC80, 0xFFB0BEC5,
  0xFF90A4AE, 0xFFF8BBD0, 0xFFAED581, 0xFF455A64,
];

/// 문 종류 선택지.
const doorTypeLabels = <String?, String>{
  null: '없음',
  'single': '여닫이 1짝',
  'double': '여닫이 여러 짝',
  'drawer': '서랍',
};

/// 직접 입력 / 크기 수정 폼 결과.
class FurnitureFormResult {
  const FurnitureFormResult({required this.spec, required this.saveToMine});

  final FurnitureSpec spec;
  final bool saveToMine;
}

/// 가구 사양 입력/수정 다이얼로그.
///
/// [initial]이 있으면 수정 모드. [allowSaveToMine]이면 "내 가구에 저장" 옵션 노출.
Future<FurnitureFormResult?> showFurnitureForm(
  BuildContext context, {
  FurnitureSpec? initial,
  bool allowSaveToMine = true,
  String title = '직접 입력',
}) => showDialog<FurnitureFormResult>(
  context: context,
  builder: (_) => _FurnitureFormDialog(
    initial: initial,
    allowSaveToMine: allowSaveToMine,
    title: title,
  ),
);

class _FurnitureFormDialog extends StatefulWidget {
  const _FurnitureFormDialog({
    required this.initial,
    required this.allowSaveToMine,
    required this.title,
  });

  final FurnitureSpec? initial;
  final bool allowSaveToMine;
  final String title;

  @override
  State<_FurnitureFormDialog> createState() => _FurnitureFormDialogState();
}

class _FurnitureFormDialogState extends State<_FurnitureFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name ?? '');
  late final _w = TextEditingController(
    text: widget.initial?.widthMm.toString() ?? '',
  );
  late final _d = TextEditingController(
    text: widget.initial?.depthMm.toString() ?? '',
  );
  late final _h = TextEditingController(
    text: widget.initial?.heightMm?.toString() ?? '',
  );
  late final _swing = TextEditingController(
    text: widget.initial?.doorSwingMm?.toString() ?? '',
  );
  late int _color = widget.initial?.colorValue ?? furniturePalette.first;
  late String? _doorType = widget.initial?.doorType;
  bool _saveToMine = false;

  @override
  void dispose() {
    for (final c in [_name, _w, _d, _h, _swing]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _mm(String? v, {bool optional = false}) {
    if (optional && (v == null || v.isEmpty)) return null;
    final n = int.tryParse(v ?? '');
    if (n == null) return '숫자';
    if (n < 50 || n > 10000) return '50~10000';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final w = int.parse(_w.text);
    final swing = _doorType == null
        ? null
        : (int.tryParse(_swing.text) ?? (_doorType == 'drawer' ? 400 : w));
    Navigator.pop(
      context,
      FurnitureFormResult(
        spec: FurnitureSpec(
          furnitureId: widget.initial?.furnitureId,
          name: _name.text.trim(),
          widthMm: w,
          depthMm: int.parse(_d.text),
          heightMm: int.tryParse(_h.text),
          colorValue: _color,
          doorType: _doorType,
          doorSwingMm: swing,
        ),
        saveToMine: _saveToMine,
      ),
    );
  }

  Widget _mmField(
    TextEditingController c,
    String label, {
    bool optional = false,
  }) => Expanded(
    child: TextFormField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        suffixText: 'mm',
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (v) => _mm(v, optional: optional),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      scrollable: true,
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: '이름',
                hintText: '예) 우리집 장롱',
                isDense: true,
              ),
              maxLength: 40,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '이름을 입력하세요' : null,
            ),
            Row(
              children: [
                _mmField(_w, '가로(폭)'),
                const SizedBox(width: 8),
                _mmField(_d, '세로(깊이)'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _mmField(_h, '높이(선택)', optional: true),
                const SizedBox(width: 8),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _doorType,
              decoration: const InputDecoration(
                labelText: '문/서랍',
                isDense: true,
              ),
              items: [
                for (final e in doorTypeLabels.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => setState(() => _doorType = v),
            ),
            if (_doorType != null) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _swing,
                decoration: InputDecoration(
                  labelText: _doorType == 'drawer' ? '서랍 빠지는 길이' : '문 한 짝 폭',
                  suffixText: 'mm',
                  helperText: '비워 두면 자동',
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _mm(v, optional: true),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in furniturePalette)
                  GestureDetector(
                    onTap: () => setState(() => _color = c),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(c),
                      child: c == _color
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            if (widget.allowSaveToMine)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _saveToMine,
                onChanged: (v) => setState(() => _saveToMine = v ?? false),
                title: const Text('내 가구에 저장'),
                subtitle: const Text('다른 배치안에서도 다시 쓸 수 있어요'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(onPressed: _submit, child: const Text('확인')),
      ],
    );
  }
}
