import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao selecionar imagem.')),
        );
      }
    }
  }

  void _publishPost() async {
    if (_selectedImage == null) return;

    final authProvider = context.read<AuthProvider>();
    final feedProvider = context.read<FeedProvider>();

    final user = authProvider.userModel;
    if (user == null || user.groupId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não está em um grupo.')),
      );
      return;
    }

    final success = await feedProvider.createPost(
      user.id,
      user.groupId,
      _selectedImage!.path,
      _captionController.text,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Momento publicado com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(feedProvider.errorMessage ?? 'Erro ao publicar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedProvider = context.watch<FeedProvider>();
    final isLoading = feedProvider.isLoading;

    return Scaffold(
      backgroundColor: AppColors.creme,
      appBar: AppBar(
        title: const Text(
          'Novo Momento',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.carvao),
          onPressed: () => isLoading ? null : Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Expanded(
                flex: 6,
                child: Container(
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
                  child: _selectedImage != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_selectedImage!, fit: BoxFit.cover),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                      onPressed: isLoading ? null : () => _pickImage(ImageSource.camera),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                                    child: IconButton(
                                      icon: const Icon(Icons.photo_library, color: Colors.white, size: 20),
                                      onPressed: isLoading ? null : () => _pickImage(ImageSource.gallery),
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
                                  onPressed: isLoading ? null : () => _pickImage(ImageSource.camera),
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
                                  onPressed: isLoading ? null : () => _pickImage(ImageSource.gallery),
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
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _captionController,
                maxLines: 2,
                enabled: !isLoading,
                decoration: InputDecoration(
                  hintText: 'Escreva uma legenda carinhosa...',
                  hintStyle: const TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno),
                  filled: true,
                  fillColor: AppColors.brancoPuro,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.azulSuave, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_selectedImage != null && !isLoading) ? _publishPost : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azulSuave,
                  foregroundColor: AppColors.brancoPuro,
                  disabledBackgroundColor: AppColors.cinzaMorno.withValues(alpha: 0.5),
                  disabledForegroundColor: AppColors.brancoPuro,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: AppColors.brancoPuro, strokeWidth: 2),
                      )
                    : const Text(
                        'Publicar',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
