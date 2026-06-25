import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MemberCard extends StatelessWidget {
  final String name;
  final String city;
  final String weather;
  final String? avatarUrl;

  const MemberCard({
    super.key,
    required this.name,
    required this.city,
    required this.weather,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
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
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
            child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.azulSuave)),
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
