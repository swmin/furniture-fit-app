import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../../../core/units.dart';

/// 새 집 만들기 바텀시트. 생성된 집 ID를 반환한다.
Future<String?> showCreateHomeSheet(BuildContext context) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const CreateHomeSheet(),
    );

enum _Source { floorPlan, emptyRoom }

class CreateHomeSheet extends ConsumerStatefulWidget {
  const CreateHomeSheet({super.key});

  @override
  ConsumerState<CreateHomeSheet> createState() => _CreateHomeSheetState();
}

class _CreateHomeSheetState extends ConsumerState<CreateHomeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: '우리 집');
  final _width = TextEditingController();
  final _depth = TextEditingController();
  _Source _source = _Source.emptyRoom;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _width.dispose();
    _depth.dispose();
    super.dispose();
  }

  String? _validateMm(String? v) {
    final n = int.tryParse(v ?? '');
    if (n == null) return '숫자를 입력하세요';
    if (n < AppConstants.minRoomMm || n > AppConstants.maxRoomMm) {
      return '${AppConstants.minRoomMm}~${AppConstants.maxRoomMm}mm';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = await ref.read(homeRepositoryProvider).createEmptyRoomHome(
          name: _name.text.trim(),
          roomWidthMm: int.parse(_width.text),
          roomDepthMm: int.parse(_depth.text),
        );
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = int.tryParse(_width.text);
    final d = int.tryParse(_depth.text);

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('새 집 만들기', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: '집 이름',
                hintText: '예) 이사 갈 집 - OO아파트 84A',
              ),
              maxLength: 60,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '이름을 입력하세요' : null,
            ),
            const SizedBox(height: 8),
            SegmentedButton<_Source>(
              segments: const [
                ButtonSegment(
                  value: _Source.floorPlan,
                  icon: Icon(Icons.image_outlined),
                  label: Text('도면 사진'),
                ),
                ButtonSegment(
                  value: _Source.emptyRoom,
                  icon: Icon(Icons.crop_square),
                  label: Text('빈 방 직접 만들기'),
                ),
              ],
              selected: {_source},
              onSelectionChanged: (s) => setState(() => _source = s.first),
            ),
            const SizedBox(height: 16),
            if (_source == _Source.floorPlan)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '📐 도면 사진 불러오기와 축척 보정은 다음 업데이트(Step 2)에서 지원됩니다.\n'
                    '지금은 "빈 방 직접 만들기"를 이용해 주세요.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _width,
                      decoration: const InputDecoration(
                          labelText: '가로', suffixText: 'mm', hintText: '3600'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateMm,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('×'),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _depth,
                      decoration: const InputDecoration(
                          labelText: '세로', suffixText: 'mm', hintText: '4200'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: _validateMm,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                w != null && d != null
                    ? '면적 약 ${formatArea(w, d)}'
                    : '방 안쪽 벽~벽 길이를 mm로 입력하세요.',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed:
                  (_source == _Source.emptyRoom && !_saving) ? _submit : null,
              child: const Text('만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
