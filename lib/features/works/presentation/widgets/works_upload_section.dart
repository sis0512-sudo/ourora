import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourora/config/theme.dart';
import 'package:ourora/features/works/domain/work_item.dart';
import 'package:ourora/features/works/infrastructure/works_repository.dart';
import 'package:web/web.dart' as web;

class WorksUploadSection extends StatefulWidget {
  const WorksUploadSection({super.key});

  @override
  State<WorksUploadSection> createState() => _WorksUploadSectionState();
}

enum _UploadStatus { idle, uploading, success, error }

class _PickedImage {
  final String name;
  final Uint8List bytes;

  const _PickedImage({required this.name, required this.bytes});
}

class _WorksUploadSectionState extends State<WorksUploadSection> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _youtubeController = TextEditingController();

  final List<_PickedImage> _selectedImages = [];
  WorkType _selectedType = WorkType.furniture;
  _UploadStatus _status = _UploadStatus.idle;
  double _progress = 0;
  String? _errorMessage;

  final _repository = WorksRepository();

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final completer = Completer<List<_PickedImage>>();

    final input = web.HTMLInputElement()
      ..type = 'file'
      ..multiple = true
      ..accept = 'image/*';

    web.document.body!.append(input);

    input.addEventListener('change', ((web.Event _) => _processInputFiles(input, completer).ignore()).toJS);

    input.click();

    final picked = await completer.future;
    if (picked.isNotEmpty && mounted) {
      setState(() => _selectedImages.addAll(picked));
    }
  }

  Future<void> _processInputFiles(web.HTMLInputElement input, Completer<List<_PickedImage>> completer) async {
    final files = input.files;
    if (files == null || files.length == 0) {
      input.remove();
      completer.complete([]);
      return;
    }

    final picked = <_PickedImage>[];
    for (var i = 0; i < files.length; i++) {
      final file = files.item(i)!;
      final bytes = await _readFileBytes(file);
      picked.add(_PickedImage(name: file.name, bytes: bytes));
    }
    input.remove();
    completer.complete(picked);
  }

  Future<Uint8List> _readFileBytes(web.File file) {
    final completer = Completer<Uint8List>();
    final reader = web.FileReader();
    reader.addEventListener(
      'load',
      ((web.Event _) {
        final buffer = (reader.result as JSArrayBuffer).toDart;
        completer.complete(buffer.asUint8List());
      }).toJS,
    );
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      setState(() => _errorMessage = '이미지를 최소 1장 이상 선택해주세요.');
      return;
    }

    setState(() {
      _status = _UploadStatus.uploading;
      _progress = 0;
      _errorMessage = null;
    });

    try {
      await _repository.uploadWork(
        customId: _idController.text.trim().isEmpty ? null : _idController.text.trim(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        images: _selectedImages.map((img) => (name: img.name, bytes: img.bytes)).toList(),
        youtubeUrl: _youtubeController.text.trim().isEmpty ? null : _youtubeController.text.trim(),
        type: _selectedType,
        onProgress: (p) => setState(() => _progress = p),
      );

      setState(() {
        _status = _UploadStatus.success;
        _selectedImages.clear();
        _selectedType = WorkType.furniture;
        _idController.clear();
        _titleController.clear();
        _descController.clear();
        _youtubeController.clear();
        _progress = 0;
      });
    } catch (e) {
      setState(() {
        _status = _UploadStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        border: Border.all(color: AppTheme.accentOrange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(_idController, 'ID', '비워두면 자동 생성 (영문·숫자·하이픈)'),
                  const SizedBox(height: 16),
                  _buildTextField(_titleController, '제목', '작품 제목을 입력하세요', required: true),
                  const SizedBox(height: 16),
                  _buildTextField(_descController, '설명', '작품 설명을 입력하세요', required: true, maxLines: 4),
                  const SizedBox(height: 16),
                  _buildTextField(_youtubeController, 'YouTube URL', 'https://www.youtube.com/watch?v=...'),
                  const SizedBox(height: 20),
                  _buildTypeSection(),
                  const SizedBox(height: 20),
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(_errorMessage!, style: const TextStyle(color: AppTheme.red, fontSize: 13)),
                    ),
                  _buildSubmitButton(),
                  if (_status == _UploadStatus.success)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        '업로드 완료!',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.accentOrange,
        borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bug_report, color: AppTheme.white, size: 18),
          const SizedBox(width: 8),
          Text(
            'DEBUG — 작품 업로드',
            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.white, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool required = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textGray),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppTheme.textGray.withValues(alpha: 0.5), fontSize: 13),
            filled: true,
            fillColor: AppTheme.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppTheme.borderGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppTheme.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppTheme.accentOrange, width: 1.5),
            ),
          ),
          validator: required ? (v) => (v == null || v.trim().isEmpty) ? '$label을 입력해주세요.' : null : null,
        ),
      ],
    );
  }

  Widget _buildTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '타입',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textGray),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: WorkType.values.map((tag) {
            final selected = _selectedType.name == tag.name;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedType = tag;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? AppTheme.accentOrange : AppTheme.white,
                  border: Border.all(color: selected ? AppTheme.accentOrange : AppTheme.borderGray),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag.name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? AppTheme.white : AppTheme.textGray),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '이미지',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textGray),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
              label: const Text('이미지 추가', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accentOrange,
                side: const BorderSide(color: AppTheme.accentOrange),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_selectedImages.length, (i) {
              final img = _selectedImages[i];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(img.bytes, width: 90, height: 90, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImages.removeAt(i)),
                      child: Container(
                        decoration: const BoxDecoration(color: AppTheme.black, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.close, size: 12, color: AppTheme.white),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isUploading = _status == _UploadStatus.uploading;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUploading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentOrange,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          disabledBackgroundColor: AppTheme.accentOrange.withValues(alpha: 0.5),
        ),
        child: isUploading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('업로드 중... ${(_progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: AppTheme.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.white),
                  ),
                ],
              )
            : const Text('저장하기', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 1)),
      ),
    );
  }
}
