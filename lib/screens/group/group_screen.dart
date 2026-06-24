import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _showCodeView = false;
  final String _generatedCode = 'LCO972';
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
    return Column(
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
        // Create Group Card
        GestureDetector(
          onTap: () {
            setState(() {
              _showCodeView = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.azulSuave.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.azulSuave.withOpacity(0.3), width: 1.5),
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
        // Enter Code Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.verdeSalvia.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.verdeSalvia.withOpacity(0.3), width: 1.5),
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
                    borderSide: BorderSide(color: AppColors.cinzaMorno.withOpacity(0.2), width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_codeController.text.length == 6) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.verdeSalvia,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Entrar no Grupo', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeCreatedView() {
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
            border: Border.all(color: AppColors.cinzaMorno.withOpacity(0.2)),
          ),
          child: Center(
            child: Text(
              _generatedCode,
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
          onPressed: () {},
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
