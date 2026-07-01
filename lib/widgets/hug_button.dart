import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/hug_provider.dart';
import '../providers/auth_provider.dart';
import 'hug_overlay.dart';

/// Button that sends a virtual hug to a group member.
/// Integrates with [HugProvider] for cooldown validation and Firestore persistence.
class HugButton extends StatelessWidget {
  final String targetUid;
  final String targetName;
  final String groupId;

  const HugButton({
    super.key,
    required this.targetUid,
    required this.targetName,
    required this.groupId,
  });

  Future<void> _sendHug(BuildContext context) async {
    final hugProvider = context.read<HugProvider>();
    final authProvider = context.read<AuthProvider>();

    final fromUid = authProvider.currentUser?.uid ?? '';
    final fromName = authProvider.userModel?.name ?? 'Alguém';

    if (fromUid.isEmpty) return;

    final success = await hugProvider.sendHug(
      fromUid: fromUid,
      fromName: fromName,
      toUid: targetUid,
      toName: targetName,
      groupId: groupId,
    );

    if (!context.mounted) return;

    if (success) {
      HugOverlay.show(context, targetName);
    } else if (hugProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(hugProvider.errorMessage!),
          backgroundColor: AppColors.cinzaMorno,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HugProvider>(
      builder: (context, hugProvider, child) {
        return ElevatedButton.icon(
          onPressed: hugProvider.isSending ? null : () => _sendHug(context),
          icon: hugProvider.isSending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.favorite, color: Colors.white, size: 18),
          label: Text(
            hugProvider.isSending ? 'Enviando...' : 'Enviar Abraço 🤗',
            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
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
      },
    );
  }
}
