import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/group_provider.dart';

class CreateGroupFormView extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onBack;
  final GroupProvider groupProvider;

  const CreateGroupFormView({
    super.key,
    required this.nameController,
    required this.onBack,
    required this.groupProvider,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return SingleChildScrollView(
      child: Column(
        key: const ValueKey('CreateGroupFormView'),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.carvao),
                onPressed: onBack,
              ),
              const Text('Criar Novo Grupo', style: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.carvao)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.azulSuave.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.azulSuave.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Como se chama sua família?', style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.carvao)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Ex: Família Silva',
                    filled: true,
                    fillColor: AppColors.brancoPuro,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.azulSuave, width: 1.5)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0)),
                  ),
                ),
                const SizedBox(height: 24),
                if (groupProvider.errorMessage != null) ...[
                  Text(groupProvider.errorMessage!, style: const TextStyle(color: AppColors.coralSuave, fontSize: 14), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: groupProvider.isLoading ? null : () async {
                    if (nameController.text.isNotEmpty) {
                      final uid = authProvider.currentUser?.uid;
                      if (uid != null) {
                        final success = await groupProvider.createGroup(nameController.text, uid);
                        if (success && context.mounted) await authProvider.refreshUser();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulSuave,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: groupProvider.isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Criar e Gerar Código', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
