import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MapHeaderCard extends StatelessWidget {
  final int locationsCount;
  final bool isLoading;
  final VoidCallback onRefresh;

  const MapHeaderCard({
    super.key,
    required this.locationsCount,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: AppColors.shadowPadrao,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.coralSuave),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$locationsCount localizaç${locationsCount == 1 ? "ão" : "ões"} ativa${locationsCount == 1 ? "" : "s"}',
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.azulSuave),
            )
          else
            GestureDetector(
              onTap: onRefresh,
              child: const Icon(Icons.refresh, color: AppColors.cinzaMorno, size: 20),
            ),
        ],
      ),
    );
  }
}
