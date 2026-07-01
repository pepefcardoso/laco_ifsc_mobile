import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_colors.dart';
import 'online_indicator.dart';

class MemberCard extends StatelessWidget {
  final String name;
  final String city;
  final String weather;
  final String? avatarUrl;
  final String uid;
  final Timestamp? lastSeen;

  const MemberCard({
    super.key,
    required this.name,
    required this.city,
    required this.weather,
    this.avatarUrl,
    required this.uid,
    this.lastSeen,
  });

  @override
  Widget build(BuildContext context) {
    // Online if last seen within 2 hours
    final isOnline = lastSeen != null &&
        DateTime.now().difference(lastSeen!.toDate()).inMinutes < 120;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.brancoPuro,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.azulSuave))
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: OnlineIndicator(isOnline: isOnline),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '$city • $weather',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
