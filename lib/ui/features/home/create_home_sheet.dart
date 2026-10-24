import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants.dart';
import '../../../core/providers.dart';
import '../../../core/units.dart';

/// 새 집 만들기 결과.
typedef CreateHomeResult = ({String homeId, bool needsCalibration});

/// 새 집 만들기 바텀시트.
Future<CreateHomeResult?> showCreateHomeSheet(BuildContext context) =>
    showModalBottomSheet<CreateHomeResult>(
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
  final _picker = ImagePicker();
  _Source _source = _Source.floorPlan;
  XFile? _image;
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

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        // 너무 큰 원본은 메모리·저장 공간을 낭비하므로 긴 변 4000px로 제한.
        maxWidth: 4000,
        maxHeight: 4000,
        imageQuality: 92,
      );
      if (file != null) setState(() => _image = file);
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('이미지를 불러오지 못했습니다: ${e.message}')));
    }
  }

  bool get _canSubmit =>
      !_saving && (_source == _Source.emptyRoom || _image != null);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(homeRepositoryProvider);
    try {
      final CreateHomeResult result;
      if (_source == _Source.floorPlan) {
        final id = await repo.createFloorPlanHome(
          name: _name.text.trim(),
          sourceImagePath: _image!.path,
        );
        result = (homeId: id, needsCalibration: true);
      } else {
        final id = await repo.createEmptyRoomHome(
          name: _name.text.trim(),
          roomWidthMm: int.parse(_width.text),
          roomDepthMm: int.parse(_depth.text),
        );
        result = (homeId: id, needsCalibration: false);
      }
      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('집을 만들지 못했습니다: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
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
                _floorPlanSection(theme)
              else
                _emptyRoomSection(theme),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _canSubmit ? _submit : null,
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_source == _Source.floorPlan ? '다음: 축척 맞추기' : '만들기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floorPlanSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 180,
              color: theme.colorScheme.surfaceContainerHighest,
              child: Image.file(File(_image!.path), fit: BoxFit.contain),
            ),
          )
        else
          Text(
            '네이버 부동산 등에서 캡처한 평면도나 종이 도면 사진을 불러오세요.\n'
            '다음 단계에서 길이를 아는 벽 하나만 찍으면 실제 축척이 맞춰집니다.',
            style: theme.textTheme.bodySmall,
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(_image == null ? '갤러리' : '다시 선택'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pick(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('카메라'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emptyRoomSection(ThemeData theme) {
    final w = int.tryParse(_width.text);
    final d = int.tryParse(_depth.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _width,
                decoration: const InputDecoration(
                  labelText: '가로',
                  suffixText: 'mm',
                  hintText: '3600',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateMm,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 18, 8, 0),
              child: Text('×'),
            ),
            Expanded(
              child: TextFormField(
                controller: _depth,
                decoration: const InputDecoration(
                  labelText: '세로',
                  suffixText: 'mm',
                  hintText: '4200',
                ),
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
    );
  }
}
