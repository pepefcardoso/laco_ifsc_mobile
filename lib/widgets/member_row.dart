import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../models/user_model.dart';
import 'online_indicator.dart';

class MemberRow extends StatelessWidget {
  final List<UserModel> members;

  const MemberRow({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membros do Grupo',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.carvao,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppColors.gapCards),
            itemBuilder: (context, index) {
              final member = members[index];
              final isOnline = member.lastSeen != null &&
                  DateTime.now().difference(member.lastSeen!.toDate()).inMinutes < 120;
              return Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brancoPuro,
                  borderRadius: BorderRadius.circular(AppColors.radiusCard),
                  boxShadow: AppColors.shadowPadrao,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                          backgroundImage: member.photoUrl.isNotEmpty ? CachedNetworkImageProvider(member.photoUrl) : null,
                          child: member.photoUrl.isEmpty
                              ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.bold))
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: OnlineIndicator(isOnline: isOnline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      '-',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 8, color: AppColors.cinzaMorno),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
