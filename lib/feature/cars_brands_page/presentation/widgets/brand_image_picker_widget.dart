import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import 'package:web_admin_san/core/helpers/utils/image_compressor.dart';

class BrandImagePickerWidget extends StatefulWidget {
  final Uint8List? initialImageBytes;
  final ValueChanged<String?> onImageChanged;
  final double size;

  const BrandImagePickerWidget({
    super.key,
    this.initialImageBytes,
    required this.onImageChanged,
    this.size = 96,
  });

  @override
  State<BrandImagePickerWidget> createState() => _BrandImagePickerWidgetState();
}

class _BrandImagePickerWidgetState extends State<BrandImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _currentBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentBytes = widget.initialImageBytes;
  }

  Future<void> _pickImage() async {
    try {
      setState(() => _isLoading = true);
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file == null) {
        setState(() => _isLoading = false);
        return;
      }

      final rawBytes = await file.readAsBytes();
      final compressed = await ImageCompressor.compressImage(
        rawBytes,
        minWidth: 400,
        minHeight: 400,
        quality: 75,
      );

      final finalBytes = compressed ?? rawBytes;
      final base64String = base64Encode(finalBytes);

      if (!mounted) return;
      setState(() {
        _currentBytes = finalBytes;
        _isLoading = false;
      });

      widget.onImageChanged(base64String);
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _removeImage() {
    setState(() {
      _currentBytes = null;
    });
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.scaffoldColor,
                  border: Border.all(
                    color: AppColors.orangeColor.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkColor.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.orangeColor,
                            ),
                          ),
                        )
                      : _currentBytes != null && _currentBytes!.isNotEmpty
                          ? Image.memory(
                              _currentBytes!,
                              width: widget.size,
                              height: widget.size,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.directions_car,
                                size: 40,
                                color: AppColors.darkGreyColor,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.directions_car_outlined,
                                size: 44,
                                color: AppColors.darkGreyColor,
                              ),
                            ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.orangeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkColor.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 15,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          if (_currentBytes != null && _currentBytes!.isNotEmpty)
            Positioned(
              top: -2,
              left: -2,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.errorRedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
