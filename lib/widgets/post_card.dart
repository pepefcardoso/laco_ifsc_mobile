import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PostCard extends StatelessWidget {
  final String authorName;
  final String imageUrl;
  final String caption;
  final String timeAgo;
  final VoidCallback? onReact;

  const PostCard({
    super.key,
    required this.authorName,
    required this.imageUrl,
    required this.caption,
    required this.timeAgo,
    this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brancoPuro,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.coralSuave,
                  child: Text(authorName[0], style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Text(
                  authorName,
                  style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  timeAgo,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno),
                ),
              ],
            ),
          ),
          // Image Area
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              color: AppColors.cinzaMorno.withOpacity(0.1),
              child: const Icon(Icons.image, size: 48, color: AppColors.cinzaMorno),
            ),
          ),
          // Footer / Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caption,
                  style: const TextStyle(fontFamily: 'Inter', color: AppColors.carvao),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: AppColors.coralSuave),
                      onPressed: onReact,
                    ),
                    const Text('Reagir', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
