import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../providers/group_provider.dart';

class CodeCreatedView extends StatelessWidget {
  final GroupProvider groupProvider;

  const CodeCreatedView({super.key, required this.groupProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('CodeCreatedView'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.verdeSalvia, size: 80),
        const SizedBox(height: 24),
        const Text(
          'Grupo Criado!',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Nunito', fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.carvao),
        ),
        const SizedBox(height: 12),
        const Text(
          'Compartilhe este código com seus familiares para que eles possam se juntar a você no Laço.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontSize: 14),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.brancoPuro,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cinzaMorno.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              groupProvider.currentGroup!.code,
              style: const TextStyle(fontFamily: 'Nunito', fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 8, color: AppColors.azulSuave),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            SharePlus.instance.share(ShareParams(text: 'Junte-se à minha família no Laço! Baixe o app e use o código de convite: ${groupProvider.currentGroup!.code}'));
          },
          icon: const Icon(Icons.share),
          label: const Text('Compartilhar Código'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.azulSuave,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
          child: const Text('Ir para a Página Inicial', style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
