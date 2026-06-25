import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _showCodeView = false;
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creme,
      appBar: AppBar(
        title: const Text(
          'Grupo Familiar',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showCodeView ? _buildCodeCreatedView() : _buildSelectionView(),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionView() {
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
        Text(
          'Para começar, você precisa estar em um grupo.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.carvao,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crie um novo círculo para convidar sua família ou insira um código enviado por eles.',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontSize: 14),
        ),
        const SizedBox(height: 48),
        GestureDetector(
          onTap: () {
            setState(() {
              _showCodeView = true;
            });
          },
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
                  decoration: BoxDecoration(
                    color: AppColors.azulSuave,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.home, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Criar Novo Grupo',
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.carvao),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Iniciar um novo laço de amor',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: AppColors.azulSuave, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (groupProvider.errorMessage != null && !_showCodeView) ...[
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
                  child: Text(
                    groupProvider.errorMessage!,
                    style: const TextStyle(fontFamily: 'Inter', color: AppColors.carvao, fontSize: 14),
                  ),
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
                    decoration: BoxDecoration(
                      color: AppColors.verdeSalvia,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.vpn_key, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entrar com Código',
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.carvao),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Digitar convite de 6 dígitos',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.cinzaMorno),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                maxLength: 6,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'CÓDIGO',
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.brancoPuro,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.verdeSalvia, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: groupProvider.isLoading ? null : () async {
                  if (_codeController.text.length == 6) {
                    final uid = authProvider.currentUser?.uid;
                    if (uid != null) {
                      final success = await groupProvider.joinGroup(_codeController.text, uid);
                      if (success && mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
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

  Widget _buildCodeCreatedView() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context);

    if (groupProvider.currentGroup == null) {
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
                  onPressed: () {
                    setState(() {
                      _showCodeView = false;
                      _nameController.clear();
                    });
                  },
                ),
                const Text(
                  'Criar Novo Grupo',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.carvao),
                ),
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
                  const Text(
                    'Como se chama sua família?',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.carvao),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Ex: Família Silva',
                      filled: true,
                      fillColor: AppColors.brancoPuro,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.azulSuave, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: AppColors.cinzaMorno.withValues(alpha: 0.2), width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (groupProvider.errorMessage != null) ...[
                    Text(
                      groupProvider.errorMessage!,
                      style: const TextStyle(color: AppColors.coralSuave, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton(
                    onPressed: groupProvider.isLoading ? null : () async {
                      if (_nameController.text.isNotEmpty) {
                        final uid = authProvider.currentUser?.uid;
                        if (uid != null) {
                          await groupProvider.createGroup(_nameController.text, uid);
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

    return Column(
      key: const ValueKey('CodeCreatedView'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle_outline, color: AppColors.verdeSalvia, size: 80),
        const SizedBox(height: 24),
        Text(
          'Grupo Criado!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.carvao,
          ),
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
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: AppColors.azulSuave,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {
            Share.share('Junte-se à minha família no Laço! Baixe o app e use o código de convite: ${groupProvider.currentGroup!.code}');
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
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
          child: const Text(
            'Ir para a Página Inicial',
            style: TextStyle(fontFamily: 'Inter', color: AppColors.cinzaMorno, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
