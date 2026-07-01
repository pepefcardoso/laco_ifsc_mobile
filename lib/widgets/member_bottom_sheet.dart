import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import '../models/member_location_data.dart';
import 'weather_badge.dart';
import 'online_indicator.dart';
import 'hug_button.dart';

class MemberBottomSheet extends StatelessWidget {
  final MemberLocationData member;
  final String currentUserId;
  final String groupId;

  const MemberBottomSheet({
    super.key,
    required this.member,
    required this.currentUserId,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final timeAgo = member.lastSeen != null 
        ? DateFormatter.formatRelative(member.lastSeen!.toDate()) 
        : 'Desconhecido';
        
    final isOnline = member.lastSeen != null && 
        DateTime.now().difference(member.lastSeen!.toDate()).inMinutes < 120;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.creme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                backgroundImage: member.photoUrl.isNotEmpty 
                    ? CachedNetworkImageProvider(member.photoUrl) 
                    : null,
                child: member.photoUrl.isEmpty
                    ? Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.azulSuave),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.carvao,
                            ),
                          ),
                        ),
                        OnlineIndicator(isOnline: isOnline),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visto por último: $timeAgo',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.cinzaMorno,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (member.cityName != null && member.temperature != null && member.weatherIcon != null)
            WeatherBadge(
              cityName: member.cityName!,
              temperature: member.temperature!,
              weatherIcon: member.weatherIcon!,
            ),
          if (member.id != currentUserId && groupId.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: HugButton(
                targetUid: member.id,
                targetName: member.name,
                groupId: groupId,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
