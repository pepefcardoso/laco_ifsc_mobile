import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';

class PostCard extends StatelessWidget {
  final String authorName;
  final String authorPhotoUrl;
  final String imageUrl;
  final String caption;
  final String timeAgo;
  final Map<String, String> reactions;
  final String currentUserId;
  final Function(String) onReact;

  const PostCard({
    super.key,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.imageUrl,
    required this.caption,
    required this.timeAgo,
    required this.reactions,
    required this.currentUserId,
    required this.onReact,
  });

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final emojis = ['❤️', '🤗', '🥰', '👏', '😂'];
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.brancoPuro,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: emojis.map((emoji) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onReact(emoji);
                },
                child: Text(emoji, style: const TextStyle(fontSize: 32)),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group reactions
    final Map<String, int> reactionCounts = {};
    for (var emoji in reactions.values) {
      reactionCounts[emoji] = (reactionCounts[emoji] ?? 0) + 1;
    }

    final myReaction = reactions[currentUserId];

    return GestureDetector(
      onLongPress: () => _showEmojiPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.brancoPuro,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.coralSuave,
                  backgroundImage: authorPhotoUrl.isNotEmpty ? CachedNetworkImageProvider(authorPhotoUrl) : null,
                  child: authorPhotoUrl.isEmpty
                      ? Text(authorName.isNotEmpty ? authorName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12))
                      : null,
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
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              color: AppColors.cinzaMorno.withValues(alpha: 0.1),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColors.azulSuave)),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: AppColors.cinzaMorno),
                    )
                  : const Icon(Icons.image, size: 48, color: AppColors.cinzaMorno),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (caption.isNotEmpty) ...[
                  Text(
                    caption,
                    style: const TextStyle(fontFamily: 'Inter', color: AppColors.carvao),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showEmojiPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: myReaction != null ? AppColors.azulSuave.withValues(alpha: 0.2) : AppColors.cinzaMorno.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              myReaction != null ? Icons.favorite : Icons.favorite_border,
                              color: myReaction != null ? AppColors.azulSuave : AppColors.cinzaMorno,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Reagir',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: myReaction != null ? AppColors.azulSuave : AppColors.cinzaMorno,
                                fontWeight: myReaction != null ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: reactionCounts.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '${entry.key} ${entry.value}',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

