import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/group_provider.dart';
import '../../widgets/code_created_view.dart';
import '../../widgets/create_group_form_view.dart';
import '../../widgets/group_selection_view.dart';

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
        title: const Text('Grupo Familiar', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showCodeView ? _buildCodeCreatedView() : GroupSelectionView(
              onShowCodeView: () => setState(() => _showCodeView = true),
              codeController: _codeController,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeCreatedView() {
    final groupProvider = Provider.of<GroupProvider>(context);

    if (groupProvider.currentGroup == null) {
      return CreateGroupFormView(
        nameController: _nameController,
        groupProvider: groupProvider,
        onBack: () {
          setState(() {
            _showCodeView = false;
            _nameController.clear();
          });
        },
      );
    }

    return CodeCreatedView(groupProvider: groupProvider);
  }
}
