import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/hug_model.dart';
import 'hug_feed_card.dart';

class HugsSection extends StatelessWidget {
  final List<HugModel> receivedHugs;

  const HugsSection({super.key, required this.receivedHugs});

  @override
  Widget build(BuildContext context) {
    if (receivedHugs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Abraços Recebidos',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.carvao,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: receivedHugs.length > 5 ? 5 : receivedHugs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final hug = receivedHugs[index];
            return HugFeedCard(
              senderName: hug.fromName,
              sentAt: hug.sentAt.toDate(),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
