import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/feed_provider.dart';
import '../../widgets/image_picker_preview.dart';

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
        title: const Text('Novo Momento', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao)),
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
                child: ImagePickerPreview(
                  selectedImage: _selectedImage,
                  isLoading: isLoading,
                  onPickImage: _pickImage,
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
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.azulSuave, width: 1.5)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0)),
                  disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.brancoPuro, strokeWidth: 2))
                    : const Text('Publicar', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

