import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HugButton extends StatelessWidget {
  final VoidCallback onTap;

  const HugButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.favorite, color: Colors.white, size: 18),
      label: const Text(
        'Enviar Abraço 🤗',
        style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.coralSuave,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
    );
  }
}
