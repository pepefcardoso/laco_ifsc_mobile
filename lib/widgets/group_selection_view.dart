import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_routes.dart';
import '../providers/auth_provider.dart';
import '../providers/group_provider.dart';

class GroupSelectionView extends StatelessWidget {
  final VoidCallback onShowCodeView;
  final TextEditingController codeController;

  const GroupSelectionView({
    super.key,
    required this.onShowCodeView,
    required this.codeController,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context);

    if (authProvider.userModel?.groupId != null && authProvider.userModel!.groupId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      });
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        key: const ValueKey('SelectionView'),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Para começar, você precisa estar em um grupo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.carvao),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crie um novo círculo para convidar sua família ou insira um código enviado por eles.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontSize: 14),
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: onShowCodeView,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.azulSuave.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.azulSuave.withValues(alpha: 0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.azulSuave, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.home, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Criar Novo Grupo', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.carvao)),
                        SizedBox(height: 4),
                        Text('Iniciar um novo laço de amor', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.azulSuave, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (groupProvider.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.coralSuave.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.coralSuave.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.coralSuave),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(groupProvider.errorMessage!, style: const TextStyle(fontFamily: 'Inter', color: AppColors.carvao, fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.verdeSalvia.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.verdeSalvia.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.verdeSalvia, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.vpn_key, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Entrar com Código', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.carvao)),
                          SizedBox(height: 4),
                          Text('Digitar convite de 6 dígitos', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: codeController,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'CÓDIGO',
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.brancoPuro,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.verdeSalvia, width: 1.5)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: groupProvider.isLoading ? null : () async {
                    if (codeController.text.length == 6) {
                      final uid = authProvider.currentUser?.uid;
                      if (uid != null) {
                        final success = await groupProvider.joinGroup(codeController.text, uid);
                        if (success && context.mounted) {
                          await authProvider.refreshUser();
                          if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verdeSalvia,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: groupProvider.isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Entrar no Grupo', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
