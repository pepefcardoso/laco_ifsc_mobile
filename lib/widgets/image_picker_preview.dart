import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_colors.dart';

class ImagePickerPreview extends StatelessWidget {
  final File? selectedImage;
  final bool isLoading;
  final Function(ImageSource) onPickImage;

  const ImagePickerPreview({
    super.key,
    required this.selectedImage,
    required this.isLoading,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.brancoPuro,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: selectedImage != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.file(selectedImage!, fit: BoxFit.cover),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: isLoading ? null : () => onPickImage(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.white, size: 20),
                          onPressed: isLoading ? null : () => onPickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, size: 64, color: AppColors.azulSuave.withValues(alpha: 0.8)),
                const SizedBox(height: 16),
                const Text(
                  'Escolha uma foto do seu dia',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: AppColors.carvao),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : () => onPickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Câmera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulSuave,
                        foregroundColor: AppColors.brancoPuro,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : () => onPickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeria'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.azulSuave,
                        side: const BorderSide(color: AppColors.azulSuave),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
